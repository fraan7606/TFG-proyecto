import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

// Cargar variables de entorno
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors({
  origin: true, // Permite cualquier origen en desarrollo (necesario para Flutter Web)
  credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rutas básicas
app.get('/', (req, res) => {
  res.json({
    message: 'RosTectic API - Sistema de gestión de citas',
    version: '1.0.0',
    status: 'running'
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Importar rutas
import authRoutes from './routes/auth.routes.js';
// import userRoutes from './routes/user.routes.js';
import serviceRoutes from './routes/service.routes.js';
import appointmentRoutes from './routes/appointment.routes.js';
import specialistRoutes from './routes/specialist.routes.js';

// Usar rutas
app.use('/api/auth', authRoutes);
// app.use('/api/users', userRoutes);
app.use('/api/services', serviceRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/specialists', specialistRoutes);

// Manejo de errores
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(err.status || 500).json({
    error: {
      message: err.message || 'Error interno del servidor',
      status: err.status || 500
    }
  });
});

// Ruta no encontrada
app.use((req, res) => {
  res.status(404).json({
    error: {
      message: 'Ruta no encontrada',
      status: 404
    }
  });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`🚀 Servidor RosTectic corriendo en http://localhost:${PORT}`);
  console.log(`📝 Entorno: ${process.env.NODE_ENV || 'development'}`);
});

export default app;
