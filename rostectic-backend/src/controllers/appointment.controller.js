import { addMinutes, format, parseISO, startOfDay, endOfDay, isBefore, isAfter, eachMinuteOfInterval } from 'date-fns';
import prisma from '../config/database.js';

// Configuración de horario (Esto podría ir en una tabla de configuración después)
const OPENING_HOUR = 9; // 09:00
const CLOSING_HOUR = 19; // 19:00
const SLOT_INTERVAL = 15; // Intervalos de 15 minutos para empezar

export const getAvailableSlots = async (req, res, next) => {
    try {
        const { date, serviceId, specialistId } = req.query;

        if (!date || !serviceId) {
            return res.status(400).json({ message: 'Se requiere fecha y ID de servicio' });
        }

        const service = await prisma.service.findUnique({ where: { id: serviceId } });
        if (!service) {
            return res.status(404).json({ message: 'Servicio no encontrado' });
        }

        const selectedDate = parseISO(date);
        const startOfSelectedDay = startOfDay(selectedDate);
        const endOfSelectedDay = endOfDay(selectedDate);

        // 1. Obtener citas existentes para ese día y especialista específico
        const whereClause = {
            scheduledAt: {
                gte: startOfSelectedDay,
                lte: endOfSelectedDay
            },
            status: {
                in: ['PENDING', 'CONFIRMED']
            }
        };

        // Si se especifica un especialista, filtrar solo sus citas
        if (specialistId && specialistId !== '0') {
            whereClause.specialistId = specialistId;
        }

        const appointments = await prisma.appointment.findMany({
            where: whereClause,
            include: { service: true }
        });

        // 1.5. Obtener horarios bloqueados para ese día y especialista
        const blockedSlotsWhere = {
            startsAt: {
                lte: endOfSelectedDay
            },
            endsAt: {
                gte: startOfSelectedDay
            }
        };

        // Si se especifica un especialista, obtener bloqueos para ese especialista o bloqueos generales
        if (specialistId && specialistId !== '0') {
            blockedSlotsWhere.OR = [
                { specialistId: specialistId },
                { specialistId: null }
            ];
        }

        const blockedSlots = await prisma.blockedTimeSlot.findMany({
            where: blockedSlotsWhere
        });

        // 2. Definir rango de trabajo para ese día
        const workStart = new Date(selectedDate).setHours(OPENING_HOUR, 0, 0, 0);
        const workEnd = new Date(selectedDate).setHours(CLOSING_HOUR, 0, 0, 0);

        // 3. Generar posibles slots
        const slots = [];
        let currentSlot = workStart;

        while (isBefore(currentSlot, workEnd)) {
            const slotStart = new Date(currentSlot);
            const slotEnd = addMinutes(slotStart, service.durationMinutes);

            // Verificar si el slot termina después de la hora de cierre
            if (isAfter(slotEnd, workEnd)) break;

            // Verificar si el slot se solapa con alguna cita existente
            const isOverlap = appointments.some(app => {
                const appStart = new Date(app.scheduledAt);
                const appEnd = addMinutes(appStart, app.service.durationMinutes);

                // Hay solapamiento si:
                // (Inicio nuevo < Fin existente) Y (Fin nuevo > Inicio existente)
                return isBefore(slotStart, appEnd) && isAfter(slotEnd, appStart);
            });

            // Verificar si el slot se solapa con algún horario bloqueado
            const isBlocked = blockedSlots.some(blocked => {
                const blockedStart = new Date(blocked.startsAt);
                const blockedEnd = new Date(blocked.endsAt);

                // Hay solapamiento si:
                // (Inicio nuevo < Fin bloqueado) Y (Fin nuevo > Inicio bloqueado)
                return isBefore(slotStart, blockedEnd) && isAfter(slotEnd, blockedStart);
            });

            // Verificar si el slot es en el pasado (si es hoy)
            const now = new Date();
            const isPast = isBefore(slotStart, now);

            if (!isOverlap && !isBlocked && !isPast) {
                slots.push(format(slotStart, "HH:mm"));
            }

            currentSlot = addMinutes(currentSlot, SLOT_INTERVAL);
        }

        res.json({
            status: 'success',
            data: { slots }
        });
    } catch (error) {
        next(error);
    }
};

export const createAppointment = async (req, res, next) => {
    try {
        const { serviceId, scheduledAt, notes, specialistId } = req.body;
        const userId = req.user.id; // Del middleware de autenticación

        // Validar si el slot sigue disponible
        const service = await prisma.service.findUnique({ where: { id: serviceId } });
        const appointmentDate = parseISO(scheduledAt);
        const appointmentEnd = addMinutes(appointmentDate, service.durationMinutes);

        // Validar solapamiento solo para el especialista específico
        const overlapWhere = {
            status: { in: ['PENDING', 'CONFIRMED'] },
            scheduledAt: {
                lt: appointmentEnd,
                gte: appointmentDate
            }
        };

        // Si hay especialista, validar solo para ese especialista
        if (specialistId && specialistId !== '0') {
            overlapWhere.specialistId = specialistId;
        }

        const overlap = await prisma.appointment.findFirst({
            where: overlapWhere
        });

        if (overlap) {
            return res.status(400).json({ message: 'Este horario ya no está disponible' });
        }

        const appointment = await prisma.appointment.create({
            data: {
                userId,
                serviceId,
                specialistId: (specialistId && specialistId !== '0') ? specialistId : null,
                scheduledAt: appointmentDate,
                notes,
                status: 'PENDING'
            },
            include: {
                service: true,
                specialist: true
            }
        });

        res.status(201).json({
            status: 'success',
            data: { appointment }
        });
    } catch (error) {
        next(error);
    }
};

export const getMyAppointments = async (req, res, next) => {
    try {
        const userId = req.user.id;
        const appointments = await prisma.appointment.findMany({
            where: { userId },
            include: { service: true },
            orderBy: { scheduledAt: 'desc' }
        });

        res.json({
            status: 'success',
            data: { appointments }
        });
    } catch (error) {
        next(error);
    }
};

export const deleteAppointment = async (req, res, next) => {
    try {
        const { id } = req.params;
        const userId = req.user.id;

        // Verificar que la cita existe y pertenece al usuario
        const appointment = await prisma.appointment.findUnique({
            where: { id }
        });

        if (!appointment) {
            return res.status(404).json({ message: 'Cita no encontrada' });
        }

        if (appointment.userId !== userId && req.user.role !== 'ADMIN') {
            return res.status(403).json({ message: 'No tienes permiso para eliminar esta cita' });
        }

        await prisma.appointment.delete({
            where: { id }
        });

        res.json({
            status: 'success',
            message: 'Cita eliminada correctamente'
        });
    } catch (error) {
        next(error);
    }
};
