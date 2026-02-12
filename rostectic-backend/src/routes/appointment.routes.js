import { Router } from 'express';
import { getAvailableSlots, createAppointment, getMyAppointments } from '../controllers/appointment.controller.js';
import { authenticate } from '../middleware/auth.middleware.js';

const router = Router();

router.use(authenticate);

router.get('/slots', getAvailableSlots);
router.post('/', createAppointment);
router.get('/me', getMyAppointments);

export default router;
