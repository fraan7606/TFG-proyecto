import prisma from '../config/database.js';

export const getServices = async (req, res, next) => {
    try {
        const services = await prisma.service.findMany({
            where: { active: true }
        });

        res.json({
            status: 'success',
            data: { services }
        });
    } catch (error) {
        next(error);
    }
};

export const getServiceById = async (req, res, next) => {
    try {
        const { id } = req.params;
        const service = await prisma.service.findUnique({
            where: { id }
        });

        if (!service) {
            return res.status(404).json({ message: 'Servicio no encontrado' });
        }

        res.json({
            status: 'success',
            data: { service }
        });
    } catch (error) {
        next(error);
    }
};

export const createService = async (req, res, next) => {
    try {
        const { name, description, durationMinutes, price } = req.body;
        
        const service = await prisma.service.create({
            data: {
                name,
                description,
                durationMinutes: parseInt(durationMinutes),
                price: parseFloat(price)
            }
        });
        
        res.status(201).json({
            status: 'success',
            data: { service }
        });
    } catch (error) {
        next(error);
    }
};

export const updateService = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { name, description, durationMinutes, price, active } = req.body;
        
        const service = await prisma.service.update({
            where: { id },
            data: {
                name,
                description,
                durationMinutes: durationMinutes !== undefined ? parseInt(durationMinutes) : undefined,
                price: price !== undefined ? parseFloat(price) : undefined,
                active: active !== undefined ? active : undefined
            }
        });
        
        res.json({
            status: 'success',
            data: { service }
        });
    } catch (error) {
        next(error);
    }
};

export const deleteService = async (req, res, next) => {
    try {
        const { id } = req.params;
        
        // Soft delete - marcar como inactivo
        const service = await prisma.service.update({
            where: { id },
            data: { active: false }
        });
        
        res.json({
            status: 'success',
            data: { service },
            message: 'Servicio desactivado correctamente'
        });
    } catch (error) {
        next(error);
    }
};
