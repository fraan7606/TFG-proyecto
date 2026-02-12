import express from 'express';
import {
    getSpecialists,
    createSpecialist,
    updateSpecialist,
    deleteSpecialist
} from '../controllers/specialist.controller.js';
import { authenticate, requireAdmin } from '../middleware/auth.middleware.js';

const router = express.Router();

// Rutas públicas (para que los clientes vean quién les atiende)
router.get('/', getSpecialists);

// Rutas protegidas (Solo Admin puede gestionar perfiles)
router.post('/', authenticate, requireAdmin, createSpecialist);
router.put('/:id', authenticate, requireAdmin, updateSpecialist);
router.delete('/:id', authenticate, requireAdmin, deleteSpecialist);

export default router;
