import bcrypt from 'bcrypt';
import prisma from '../config/database.js';
import { generateToken } from '../utils/jwt.js';

export const register = async (req, res, next) => {
    try {
        const { name, email, phone, password, role } = req.body;
        const normalizedEmail = email ? email.toLowerCase() : undefined;

        // Verificar si ya existe el usuario
        const existingUser = await prisma.user.findFirst({
            where: {
                OR: [
                    { email: normalizedEmail || undefined },
                    { phone: phone || undefined }
                ]
            }
        });

        if (existingUser) {
            return res.status(400).json({
                message: 'El usuario ya existe con ese email o teléfono'
            });
        }

        // Encriptar contraseña
        const salt = await bcrypt.genSalt(10);
        const passwordHash = await bcrypt.hash(password, salt);

        // Crear usuario
        const user = await prisma.user.create({
            data: {
                name,
                email: normalizedEmail,
                phone,
                passwordHash,
                authMethod: email ? 'EMAIL' : 'PHONE',
                role: role || 'CLIENT'
            }
        });

        const token = generateToken({ id: user.id, role: user.role });

        res.status(201).json({
            status: 'success',
            token,
            data: {
                user: {
                    id: user.id,
                    name: user.name,
                    email: user.email,
                    phone: user.phone,
                    role: user.role,
                    authMethod: user.authMethod,
                    createdAt: user.createdAt
                }
            }
        });
    } catch (error) {
        next(error);
    }
};

export const login = async (req, res, next) => {
    try {
        const { email, phone, password } = req.body;
        const normalizedEmail = email ? email.toLowerCase() : undefined;

        // Buscar usuario
        const user = await prisma.user.findFirst({
            where: {
                OR: [
                    { email: normalizedEmail || undefined },
                    { phone: phone || undefined }
                ]
            }
        });

        if (!user) {
            return res.status(401).json({
                message: 'Credenciales inválidas'
            });
        }

        // Verificar contraseña
        const isMatch = await bcrypt.compare(password, user.passwordHash);
        if (!isMatch) {
            return res.status(401).json({
                message: 'Credenciales inválidas'
            });
        }

        const token = generateToken({ id: user.id, role: user.role });

        res.json({
            status: 'success',
            token,
            data: {
                user: {
                    id: user.id,
                    name: user.name,
                    email: user.email,
                    phone: user.phone,
                    role: user.role,
                    authMethod: user.authMethod,
                    createdAt: user.createdAt
                }
            }
        });
    } catch (error) {
        next(error);
    }
};
