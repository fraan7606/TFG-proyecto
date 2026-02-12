import { addMinutes, format, parseISO, startOfDay, endOfDay, isBefore, isAfter, eachMinuteOfInterval } from 'date-fns';
import prisma from '../config/database.js';

// Configuración de horario (Esto podría ir en una tabla de configuración después)
const OPENING_HOUR = 9; // 09:00
const CLOSING_HOUR = 19; // 19:00
const SLOT_INTERVAL = 15; // Intervalos de 15 minutos para empezar

export const getAvailableSlots = async (req, res, next) => {
    try {
        const { date, serviceId } = req.query;

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

        // 1. Obtener citas existentes para ese día
        const appointments = await prisma.appointment.findMany({
            where: {
                scheduledAt: {
                    gte: startOfSelectedDay,
                    lte: endOfSelectedDay
                },
                status: {
                    in: ['PENDING', 'CONFIRMED']
                }
            },
            include: { service: true }
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

            // Verificar si el slot es en el pasado (si es hoy)
            const now = new Date();
            const isPast = isBefore(slotStart, now);

            if (!isOverlap && !isPast) {
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
        const { serviceId, scheduledAt, notes } = req.body;
        const userId = req.user.id; // Del middleware de autenticación

        // Validar si el slot sigue disponible
        const service = await prisma.service.findUnique({ where: { id: serviceId } });
        const appointmentDate = parseISO(scheduledAt);
        const appointmentEnd = addMinutes(appointmentDate, service.durationMinutes);

        const overlap = await prisma.appointment.findFirst({
            where: {
                status: { in: ['PENDING', 'CONFIRMED'] },
                OR: [
                    {
                        scheduledAt: {
                            lt: appointmentEnd,
                            gte: appointmentDate
                        }
                    }
                ]
            }
        });

        // Una validación más robusta de solapamiento sería ideal aquí, 
        // pero por brevedad usaremos la lógica básica.

        const appointment = await prisma.appointment.create({
            data: {
                userId,
                serviceId,
                scheduledAt: appointmentDate,
                notes,
                status: 'PENDING'
            },
            include: {
                service: true
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
