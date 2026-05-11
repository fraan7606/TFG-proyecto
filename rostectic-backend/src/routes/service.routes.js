import { Router } from 'express';
import { 
    getServices, 
    getServiceById,
    createService,
    updateService,
    deleteService
} from '../controllers/service.controller.js';
import { authenticate, requireAdmin } from '../middleware/auth.middleware.js';

const router = Router();

router.get('/', getServices);
router.get('/:id', getServiceById);

// Rutas protegidas para admin
router.post('/', authenticate, requireAdmin, createService);
router.put('/:id', authenticate, requireAdmin, updateService);
router.delete('/:id', authenticate, requireAdmin, deleteService);

export default router;
