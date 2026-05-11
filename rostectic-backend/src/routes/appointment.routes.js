import { Router } from 'express';
import { getAvailableSlots, createAppointment, getMyAppointments, deleteAppointment } from '../controllers/appointment.controller.js';
import { authenticate } from '../middleware/auth.middleware.js';

const router = Router();

router.use(authenticate);

router.get('/slots', getAvailableSlots);
router.post('/', createAppointment);
router.get('/me', getMyAppointments);
router.delete('/:id', deleteAppointment);

export default router;
