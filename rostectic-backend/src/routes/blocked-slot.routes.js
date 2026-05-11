import { Router } from 'express';
import {
    getBlockedSlots,
    getBlockedSlotById,
    createBlockedSlot,
    updateBlockedSlot,
    deleteBlockedSlot
} from '../controllers/blocked-slot.controller.js';
import { authenticate, requireAdmin } from '../middleware/auth.middleware.js';

const router = Router();

router.use(authenticate);

router.get('/', getBlockedSlots);
router.get('/:id', getBlockedSlotById);
router.post('/', requireAdmin, createBlockedSlot);
router.put('/:id', requireAdmin, updateBlockedSlot);
router.delete('/:id', requireAdmin, deleteBlockedSlot);

export default router;
