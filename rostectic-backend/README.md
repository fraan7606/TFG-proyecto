# RosTectic Backend

Backend API para RosTectic - Sistema de gestión de citas para salón de estética.

## 🚀 Tecnologías

- **Node.js** v18+
- **Express.js** - Framework web
- **Prisma** - ORM
- **PostgreSQL** - Base de datos
- **JWT** - Autenticación
- **SendGrid** - Envío de emails
- **Twilio** - Envío de SMS

## 📋 Requisitos Previos

1. **Node.js** v18 o superior
2. **PostgreSQL** instalado y corriendo
3. **npm** o **yarn**

## 🔧 Instalación

### 1. Instalar dependencias

```bash
npm install
```

### 2. Configurar variables de entorno

Copia el archivo `.env.example` a `.env` y configura las variables:

```bash
cp .env.example .env
```

Edita el archivo `.env` con tus credenciales:

```env
DATABASE_URL="postgresql://usuario:password@localhost:5432/rostectic?schema=public"
JWT_SECRET=tu_clave_secreta_muy_segura
SENDGRID_API_KEY=tu_api_key
TWILIO_ACCOUNT_SID=tu_sid
TWILIO_AUTH_TOKEN=tu_token
```

### 3. Configurar Base de Datos

#### Crear la base de datos PostgreSQL

```bash
# Acceder a PostgreSQL
psql -U postgres

# Crear base de datos
CREATE DATABASE rostectic;

# Salir
\q
```

#### Ejecutar migraciones de Prisma

```bash
npm run db:migrate
```

### 4. Iniciar el servidor

#### Modo desarrollo (con auto-reload)

```bash
npm run dev
```

#### Modo producción

```bash
npm start
```

El servidor estará corriendo en `http://localhost:3000`

## 📁 Estructura del Proyecto

```
rostectic-backend/
├── src/
│   ├── config/          # Configuraciones (DB, etc)
│   ├── controllers/     # Controladores de rutas
│   ├── middleware/      # Middlewares (auth, validación)
│   ├── routes/          # Definición de rutas
│   ├── services/        # Lógica de negocio
│   ├── utils/           # Utilidades (JWT, email, SMS)
│   └── server.js        # Punto de entrada
├── prisma/
│   ├── schema.prisma    # Esquema de base de datos
│   └── migrations/      # Migraciones
├── .env                 # Variables de entorno (no commitear)
├── .env.example         # Ejemplo de variables
└── package.json
```

## 🔑 API Endpoints (Próximamente)

### Autenticación
- `POST /api/auth/register/email` - Registro con email
- `POST /api/auth/register/phone` - Registro con teléfono
- `POST /api/auth/login/email` - Login con email
- `POST /api/auth/login/phone` - Login con teléfono

### Servicios
- `GET /api/services` - Listar servicios
- `POST /api/services` - Crear servicio (Admin)
- `PUT /api/services/:id` - Actualizar servicio (Admin)
- `DELETE /api/services/:id` - Eliminar servicio (Admin)

### Citas
- `GET /api/appointments` - Listar citas
- `POST /api/appointments` - Crear cita
- `PUT /api/appointments/:id` - Actualizar cita
- `DELETE /api/appointments/:id` - Cancelar cita

## 🛠️ Scripts Disponibles

```bash
npm run dev        # Iniciar en modo desarrollo
npm start          # Iniciar en modo producción
npm run db:migrate # Ejecutar migraciones de Prisma
npm run db:studio  # Abrir Prisma Studio (GUI para DB)
```

## 📝 Notas de Desarrollo

- Las notificaciones se envían según el método de autenticación del usuario:
  - **Email**: Si se registró con email
  - **SMS**: Si se registró con teléfono
  
- Para testing de emails en desarrollo, usa [Mailtrap](https://mailtrap.io)
- Para testing de SMS, Twilio ofrece créditos de prueba

## 🔐 Seguridad

- Las contraseñas se hashean con bcrypt
- Autenticación mediante JWT
- CORS configurado para el frontend
- Variables sensibles en `.env` (nunca commitear)

## 📄 Licencia

MIT
