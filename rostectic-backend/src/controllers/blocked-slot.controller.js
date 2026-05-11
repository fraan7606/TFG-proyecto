import prisma from '../config/database.js';

export const getBlockedSlots = async (req, res, next) => {
    try {
        const blockedSlots = await prisma.blockedTimeSlot.findMany({
            orderBy: { startsAt: 'asc' },
            include: {
                specialist: {
                    select: {
                        id: true,
                        name: true
                    }
                }
            }
        });
        res.json({
            status: 'success',
            data: { blockedSlots }
        });
    } catch (error) {
        next(error);
    }
};

export const getBlockedSlotById = async (req, res, next) => {
    try {
        const { id } = req.params;
        const blockedSlot = await prisma.blockedTimeSlot.findUnique({
            where: { id },
            include: {
                specialist: {
                    select: {
                        id: true,
                        name: true
                    }
                }
            }
        });
        if (!blockedSlot) {
            return res.status(404).json({ message: 'Horario bloqueado no encontrado' });
        }
        res.json({
            status: 'success',
            data: { blockedSlot }
        });
    } catch (error) {
        next(error);
    }
};

export const createBlockedSlot = async (req, res, next) => {
    try {
        const { startsAt, endsAt, reason, specialistId } = req.body;
        
        const blockedSlot = await prisma.blockedTimeSlot.create({
            data: {
                startsAt: new Date(startsAt),
                endsAt: new Date(endsAt),
                reason,
                specialistId: specialistId || null
            },
            include: {
                specialist: {
                    select: {
                        id: true,
                        name: true
                    }
                }
            }
        });
        
        res.status(201).json({
            status: 'success',
            data: { blockedSlot }
        });
    } catch (error) {
        next(error);
    }
};

export const updateBlockedSlot = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { startsAt, endsAt, reason, specialistId } = req.body;
        
        const blockedSlot = await prisma.blockedTimeSlot.update({
            where: { id },
            data: {
                startsAt: startsAt ? new Date(startsAt) : undefined,
                endsAt: endsAt ? new Date(endsAt) : undefined,
                reason,
                specialistId: specialistId !== undefined ? specialistId : undefined
            },
            include: {
                specialist: {
                    select: {
                        id: true,
                        name: true
                    }
                }
            }
        });
        
        res.json({
            status: 'success',
            data: { blockedSlot }
        });
    } catch (error) {
        next(error);
    }
};

export const deleteBlockedSlot = async (req, res, next) => {
    try {
        const { id } = req.params;
        
        await prisma.blockedTimeSlot.delete({
            where: { id }
        });
        
        res.json({
            status: 'success',
            message: 'Horario bloqueado eliminado correctamente'
        });
    } catch (error) {
        next(error);
    }
};
