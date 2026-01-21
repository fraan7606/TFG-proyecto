import { verifyToken } from '../utils/jwt.js';

/**
 * Middleware para verificar autenticación
 */
export const authenticate = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;

        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return res.status(401).json({
                error: 'No se proporcionó token de autenticación'
            });
        }

        const token = authHeader.substring(7); // Remover "Bearer "
        const decoded = verifyToken(token);

        // Agregar información del usuario al request
        req.user = decoded;
        next();
    } catch (error) {
        return res.status(401).json({
            error: 'Token inválido o expirado'
        });
    }
};

/**
 * Middleware para verificar rol de administrador
 */
export const requireAdmin = (req, res, next) => {
    if (req.user.role !== 'ADMIN') {
        return res.status(403).json({
            error: 'Acceso denegado. Se requiere rol de administrador'
        });
    }
    next();
};
