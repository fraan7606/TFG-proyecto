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
