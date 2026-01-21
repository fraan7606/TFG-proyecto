# 🔧 Guía Completa del Backend de RosTectic

Esta guía te explicará cómo funciona el backend de Node.js y cómo está organizado.

## 🎯 ¿Qué es Node.js + Express?

- **Node.js**: Entorno de ejecución de JavaScript en el servidor
- **Express**: Framework web minimalista para crear APIs REST
- **Prisma**: ORM (Object-Relational Mapping) para trabajar con bases de datos

---

## 🏗️ Arquitectura del Backend

```mermaid
graph LR
    A[Cliente Flutter] -->|HTTP Request| B[Express Server]
    B --> C[Middleware Auth]
    C --> D[Controller]
    D --> E[Service/Business Logic]
    E --> F[Prisma ORM]
    F --> G[(PostgreSQL)]
    G --> F
    F --> E
    E --> D
    D --> B
    B -->|HTTP Response| A
```

---

## 📂 Estructura del Backend

```
rostectic-backend/
├── src/
│   ├── server.js           # 🚀 Punto de entrada
│   ├── config/
│   │   └── database.js     # 🗄️ Configuración de Prisma
│   ├── middleware/
│   │   └── auth.middleware.js  # 🔐 Autenticación JWT
│   ├── utils/
│   │   └── jwt.js          # 🔑 Utilidades JWT
│   ├── controllers/        # 🎮 Controladores (próximamente)
│   ├── services/           # 💼 Lógica de negocio (próximamente)
│   └── routes/             # 🛣️ Rutas API (próximamente)
├── prisma/
│   └── schema.prisma       # 📋 Esquema de base de datos
├── package.json            # 📦 Dependencias
└── .env                    # ⚙️ Variables de entorno
```

---

## 🔍 Explicación Detallada de Cada Archivo

### 1️⃣ **package.json** - Configuración del Proyecto

**¿Qué hace?**
Define las **dependencias** y **scripts** del proyecto.

```json
{
  "name": "rostectic-backend",
  "type": "module",  // Permite usar import/export (ES6)
  "scripts": {
    "dev": "nodemon src/server.js",      // Desarrollo con auto-reload
    "start": "node src/server.js",       // Producción
    "db:migrate": "prisma migrate dev",  // Crear migraciones
    "db:studio": "prisma studio"         // GUI para ver la DB
  },
  "dependencies": {
    "express": "^4.18.2",           // Framework web
    "cors": "^2.8.5",               // Permitir peticiones desde otros dominios
    "@prisma/client": "^5.7.1",     // Cliente de Prisma
    "bcrypt": "^5.1.1",             // Encriptar contraseñas
    "jsonwebtoken": "^9.0.2",       // Crear y verificar tokens JWT
    "@sendgrid/mail": "^8.1.0",     // Enviar emails
    "twilio": "^4.20.0"             // Enviar SMS
  }
}
```

**Scripts importantes**:
- `npm run dev`: Inicia el servidor en modo desarrollo (se reinicia automáticamente al cambiar código)
- `npm run db:migrate`: Crea las tablas en la base de datos
- `npm run db:studio`: Abre una interfaz gráfica para ver los datos

---

### 2️⃣ **.env** - Variables de Entorno

**¿Qué hace?**
Guarda configuraciones **sensibles** (contraseñas, claves API, etc.).

```env
# Base de datos
DATABASE_URL="postgresql://usuario:password@localhost:5432/rostectic"

# Servidor
PORT=3000
NODE_ENV=development

# JWT (autenticación)
JWT_SECRET=clave_super_secreta_cambiar_en_produccion
JWT_EXPIRES_IN=7d

# SendGrid (emails)
SENDGRID_API_KEY=SG.xxxxxxxxxxxxx

# Twilio (SMS)
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=xxxxxxxxxxxxx
```

**⚠️ IMPORTANTE**: Este archivo **NUNCA** se sube a Git (está en `.gitignore`).

---

### 3️⃣ **prisma/schema.prisma** - Esquema de Base de Datos

**¿Qué hace?**
Define la **estructura** de las tablas en la base de datos.

```prisma
// Enums (tipos enumerados)
enum Role {
  CLIENT    // Cliente normal
  ADMIN     // Administrador del salón
}

enum AuthMethod {
  EMAIL     // Se registró con email
  PHONE     // Se registró con teléfono
}

// Modelo de Usuario
model User {
  id           String      @id @default(uuid())  // ID único automático
  name         String                            // Nombre del usuario
  email        String?     @unique               // Email (puede ser null)
  phone        String?     @unique               // Teléfono (puede ser null)
  passwordHash String      @map("password_hash") // Contraseña encriptada
  authMethod   AuthMethod  @map("auth_method")   // Método de registro
  role         Role        @default(CLIENT)      // Rol (por defecto CLIENT)
  createdAt    DateTime    @default(now())       // Fecha de creación
  
  // Relaciones
  appointments Appointment[]  // Un usuario tiene muchas citas
  reviews      Review[]       // Un usuario tiene muchas reseñas
  
  @@map("users")  // Nombre de la tabla en PostgreSQL
}
```

**Conceptos clave**:
- **@id**: Campo que identifica únicamente cada registro
- **@unique**: No puede haber valores duplicados
- **@default()**: Valor por defecto
- **String?**: El `?` significa que puede ser `null`
- **Relaciones**: `appointments Appointment[]` significa "un usuario tiene muchas citas"

**Relaciones entre tablas**:
```
User (1) -----> (N) Appointment
  ↓
  └─> (N) Review

Service (1) -----> (N) Appointment
   ↓
   └─> (N) Review
   └─> (N) ServiceProduct

Product (1) -----> (N) ServiceProduct
```

---

### 4️⃣ **src/server.js** - Servidor Principal

**¿Qué hace?**
Crea el **servidor HTTP** y define las rutas básicas.

```javascript
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

// Cargar variables de entorno desde .env
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// ===== MIDDLEWARE =====
// Son funciones que se ejecutan ANTES de llegar a las rutas

// 1. CORS: Permite peticiones desde el frontend
app.use(cors({
  origin: 'http://localhost:8080',  // URL del frontend
  credentials: true
}));

// 2. JSON: Permite recibir datos en formato JSON
app.use(express.json());

// 3. URL Encoded: Permite recibir datos de formularios
app.use(express.urlencoded({ extended: true }));

// ===== RUTAS =====

// Ruta raíz (GET http://localhost:3000/)
app.get('/', (req, res) => {
  res.json({
    message: 'RosTectic API',
    version: '1.0.0'
  });
});

// Ruta de salud (GET http://localhost:3000/health)
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// ===== MANEJO DE ERRORES =====

// Error 404 (ruta no encontrada)
app.use((req, res) => {
  res.status(404).json({
    error: { message: 'Ruta no encontrada' }
  });
});

// Error 500 (error del servidor)
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    error: { message: err.message }
  });
});

// ===== INICIAR SERVIDOR =====
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
});
```

**Flujo de una petición**:
```
Cliente hace petición
    ↓
Middleware CORS
    ↓
Middleware JSON
    ↓
Ruta correspondiente
    ↓
Respuesta al cliente
```

---

### 5️⃣ **src/config/database.js** - Cliente de Prisma

**¿Qué hace?**
Crea una **instancia única** de Prisma para conectarse a la base de datos.

```javascript
import { PrismaClient } from '@prisma/client';

// Crear cliente de Prisma
const prisma = new PrismaClient({
  log: ['query', 'error', 'warn'],  // Mostrar logs en desarrollo
});

// Cerrar conexión al terminar
process.on('beforeExit', async () => {
  await prisma.$disconnect();
});

export default prisma;
```

**Uso en otros archivos**:
```javascript
import prisma from './config/database.js';

// Obtener todos los usuarios
const users = await prisma.user.findMany();

// Crear un usuario
const newUser = await prisma.user.create({
  data: {
    name: 'Juan',
    email: 'juan@example.com',
    passwordHash: 'hash...',
    authMethod: 'EMAIL',
  }
});
```

---

### 6️⃣ **src/utils/jwt.js** - Utilidades JWT

**¿Qué hace?**
Crea y verifica **tokens JWT** para autenticación.

**¿Qué es JWT?**
JSON Web Token - Un token que contiene información del usuario encriptada.

```javascript
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET;

// Generar token
export const generateToken = (payload) => {
  return jwt.sign(payload, JWT_SECRET, {
    expiresIn: '7d'  // Expira en 7 días
  });
};

// Verificar token
export const verifyToken = (token) => {
  try {
    return jwt.verify(token, JWT_SECRET);
  } catch (error) {
    throw new Error('Token inválido');
  }
};
```

**Flujo de autenticación**:
```
1. Usuario hace login
2. Backend verifica credenciales
3. Backend genera token JWT
4. Frontend guarda token
5. Frontend envía token en cada petición
6. Backend verifica token
7. Backend permite acceso
```

**Ejemplo de token**:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIxMjMiLCJyb2xlIjoiQ0xJRU5UIn0.xxxxx
```

Contiene (encriptado):
```json
{
  "userId": "123",
  "role": "CLIENT",
  "exp": 1234567890  // Fecha de expiración
}
```

---

### 7️⃣ **src/middleware/auth.middleware.js** - Middleware de Autenticación

**¿Qué hace?**
Verifica que el usuario esté **autenticado** antes de acceder a rutas protegidas.

```javascript
import { verifyToken } from '../utils/jwt.js';

// Verificar autenticación
export const authenticate = async (req, res, next) => {
  try {
    // 1. Obtener token del header
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        error: 'No se proporcionó token'
      });
    }
    
    // 2. Extraer token (quitar "Bearer ")
    const token = authHeader.substring(7);
    
    // 3. Verificar token
    const decoded = verifyToken(token);
    
    // 4. Agregar usuario al request
    req.user = decoded;
    
    // 5. Continuar a la siguiente función
    next();
  } catch (error) {
    return res.status(401).json({
      error: 'Token inválido'
    });
  }
};

// Verificar que sea administrador
export const requireAdmin = (req, res, next) => {
  if (req.user.role !== 'ADMIN') {
    return res.status(403).json({
      error: 'Acceso denegado'
    });
  }
  next();
};
```

**Uso en rutas**:
```javascript
// Ruta protegida (requiere autenticación)
app.get('/api/profile', authenticate, (req, res) => {
  res.json({ user: req.user });
});

// Ruta solo para admins
app.delete('/api/users/:id', authenticate, requireAdmin, (req, res) => {
  // Solo admins pueden eliminar usuarios
});
```

---

## 🔄 Flujo Completo de una Petición

### Ejemplo: Login con Email

```mermaid
sequenceDiagram
    participant C as Cliente (Flutter)
    participant S as Server (Express)
    participant DB as Database (PostgreSQL)
    
    C->>S: POST /api/auth/login/email
    Note over C,S: { email: "user@example.com", password: "123456" }
    
    S->>DB: SELECT * FROM users WHERE email = ?
    DB->>S: Usuario encontrado
    
    S->>S: Verificar contraseña con bcrypt
    S->>S: Generar token JWT
    
    S->>C: 200 OK
    Note over S,C: { token: "eyJhbG...", user: {...} }
    
    C->>C: Guardar token en SecureStorage
```

---

## 🗄️ Comandos de Prisma

```bash
# Crear migración (actualizar base de datos)
npm run db:migrate

# Abrir Prisma Studio (GUI para ver datos)
npm run db:studio

# Generar cliente de Prisma (después de cambiar schema)
npx prisma generate

# Resetear base de datos (¡CUIDADO! Borra todos los datos)
npx prisma migrate reset
```

---

## 📝 Próximos Pasos (Fase 2)

Vamos a crear:

1. **Controllers**: Manejan las peticiones HTTP
2. **Services**: Lógica de negocio
3. **Routes**: Definir endpoints de la API

**Ejemplo de estructura completa**:
```
POST /api/auth/login/email
  ↓
routes/auth.routes.js (define la ruta)
  ↓
controllers/auth.controller.js (maneja la petición)
  ↓
services/auth.service.js (lógica de negocio)
  ↓
database.js (Prisma)
  ↓
PostgreSQL
```

---

## 💡 Conceptos Clave

### Middleware
Funciones que se ejecutan **antes** de llegar a la ruta final.
```javascript
app.use(middleware1);  // Se ejecuta primero
app.use(middleware2);  // Se ejecuta segundo
app.get('/ruta', handler);  // Se ejecuta al final
```

### async/await
Para operaciones asíncronas (base de datos, APIs externas).
```javascript
// ❌ Mal (no espera)
const users = prisma.user.findMany();

// ✅ Bien (espera)
const users = await prisma.user.findMany();
```

### try/catch
Para manejar errores.
```javascript
try {
  const user = await prisma.user.create({ data: {...} });
} catch (error) {
  console.error('Error:', error);
}
```

---

## ❓ Preguntas Frecuentes

### ¿Por qué usar Prisma en lugar de SQL directo?
- Más seguro (previene SQL injection)
- Autocompletado en el editor
- Migraciones automáticas
- Más fácil de mantener

### ¿Qué es bcrypt?
Librería para **encriptar contraseñas**. Nunca guardamos contraseñas en texto plano.

```javascript
import bcrypt from 'bcrypt';

// Encriptar
const hash = await bcrypt.hash('password123', 10);

// Verificar
const isValid = await bcrypt.compare('password123', hash);
```

### ¿Por qué JWT en lugar de sesiones?
- **Stateless**: No necesitas guardar sesiones en el servidor
- **Escalable**: Funciona bien con múltiples servidores
- **Móvil-friendly**: Fácil de usar en apps móviles

---

¿Tienes alguna pregunta sobre el backend? 🤔
