import { Router } from 'express';
import {
    getSales,
    getSaleById,
    createSale,
    deleteSale
} from '../controllers/sale.controller.js';
import { authenticate, requireAdmin } from '../middleware/auth.middleware.js';

const router = Router();

router.use(authenticate);
router.use(requireAdmin);

router.get('/', getSales);
router.get('/:id', getSaleById);
router.post('/', createSale);
router.delete('/:id', deleteSale);

export default router;
