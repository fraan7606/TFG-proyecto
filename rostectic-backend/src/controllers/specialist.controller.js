import prisma from '../config/database.js';

// Obtener todos los especialistas
export const getSpecialists = async (req, res, next) => {
    try {
        const specialists = await prisma.specialist.findMany({
            where: { active: true }
        });

        res.json({
            status: 'success',
            data: { specialists }
        });
    } catch (error) {
        next(error);
    }
};

// Crear un especialista (Admin)
export const createSpecialist = async (req, res, next) => {
    try {
        const { name, role, imageUrl } = req.body;

        const specialist = await prisma.specialist.create({
            data: { name, role, imageUrl }
        });

        res.status(201).json({
            status: 'success',
            data: { specialist }
        });
    } catch (error) {
        next(error);
    }
};

// Actualizar un especialista (Admin)
export const updateSpecialist = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { name, role, imageUrl, active } = req.body;

        const specialist = await prisma.specialist.update({
            where: { id },
            data: { name, role, imageUrl, active }
        });

        res.json({
            status: 'success',
            data: { specialist }
        });
    } catch (error) {
        next(error);
    }
};

// Eliminar (o desactivar) un especialista (Admin)
export const deleteSpecialist = async (req, res, next) => {
    try {
        const { id } = req.params;

        // Podríamos hacer un delete físico o un soft delete (activado = false)
        // El usuario pidió borrar así que haremos delete o desactivar.
        // Usaremos soft delete por seguridad de las citas referenciadas.
        await prisma.specialist.update({
            where: { id },
            data: { active: false }
        });

        res.status(204).json({
            status: 'success',
            data: null
        });
    } catch (error) {
        next(error);
    }
};
