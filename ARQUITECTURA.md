# Arquitectura del Proyecto RosTecTic

## 📐 Visión General

RosTecTic es un sistema de gestión para salones de estética desarrollado con arquitectura cliente-servidor, utilizando tecnologías modernas y escalables.

---

## 🏗️ Arquitectura General

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENTE (Frontend)                        │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │           Flutter Web Application                   │    │
│  │                                                      │    │
│  │  ├── UI Layer (Screens/Widgets)                    │    │
│  │  ├── State Management (Provider)                   │    │
│  │  ├── Services (API Service)                        │    │
│  │  └── Models (Data Models)                          │    │
│  └────────────────────────────────────────────────────┘    │
│                          │                                   │
│                          │ HTTP/REST                         │
│                          ▼                                   │
└─────────────────────────────────────────────────────────────┘
                           │
                           │
┌──────────────────────────┼──────────────────────────────────┐
│                    SERVIDOR (Backend)                        │
│                          │                                   │
│  ┌────────────────────────────────────────────────────┐    │
│  │           Express.js REST API                       │    │
│  │                                                      │    │
│  │  ├── Routes (Endpoints)                            │    │
│  │  ├── Controllers (Business Logic)                  │    │
│  │  ├── Middleware (Auth, Validation)                 │    │
│  │  └── Utils (JWT, Helpers)                          │    │
│  └────────────────────────────────────────────────────┘    │
│                          │                                   │
│                          │ Prisma ORM                        │
│                          ▼                                   │
│  ┌────────────────────────────────────────────────────┐    │
│  │              PostgreSQL Database                    │    │
│  │                                                      │    │
│  │  ├── Users                                          │    │
│  │  ├── Services                                       │    │
│  │  ├── Appointments                                   │    │
│  │  ├── Specialists                                    │    │
│  │  ├── Products                                       │    │
│  │  ├── Sales                                          │    │
│  │  └── BlockedTimeSlots                              │    │
│  └────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎨 Frontend - Flutter Web

### Estructura de Carpetas

```
lib/
├── config/              # Configuraciones
│   ├── api_config.dart  # URLs y configuración de API
│   ├── routes.dart      # Rutas de navegación
│   └── theme.dart       # Tema y estilos
├── models/              # Modelos de datos
│   ├── appointment_model.dart
│   ├── service_model.dart
│   └── specialist_model.dart
├── providers/           # State Management (Provider)
│   ├── auth_provider.dart
│   └── booking_provider.dart
├── screens/             # Pantallas de la aplicación
│   ├── auth/           # Autenticación
│   │   └── login_screen.dart
│   ├── admin/          # Panel de administración
│   │   ├── dashboard_screen.dart
│   │   ├── manage_services_screen.dart
│   │   ├── manage_products_screen.dart
│   │   ├── manage_specialists_screen.dart
│   │   ├── manage_blocked_slots_screen.dart
│   │   ├── reports_screen.dart
│   │   └── sales_screen.dart
│   └── user/           # Pantallas de usuario
│       ├── booking_screen.dart
│       └── my_appointments_screen.dart
├── services/            # Servicios
│   └── api_service.dart # Cliente HTTP
└── main.dart           # Punto de entrada
```

### Patrones de Diseño

1. **Provider Pattern**: Gestión de estado reactiva
2. **Repository Pattern**: Abstracción de la capa de datos (API Service)
3. **MVC**: Separación de vistas, lógica y datos
4. **Singleton**: API Service como instancia única

### Flujo de Datos

```
User Action → Screen → Provider → API Service → Backend
                ↓                                    ↓
            UI Update ← Provider ← Response ← Backend
```

---

## ⚙️ Backend - Node.js + Express

### Estructura de Carpetas

```
src/
├── config/              # Configuraciones
│   └── database.js      # Configuración de Prisma
├── controllers/         # Lógica de negocio
│   ├── auth.controller.js
│   ├── appointment.controller.js
│   ├── service.controller.js
│   ├── specialist.controller.js
│   ├── product.controller.js
│   ├── sale.controller.js
│   └── blocked-slot.controller.js
├── middleware/          # Middlewares
│   └── auth.middleware.js
├── routes/              # Definición de rutas
│   ├── auth.routes.js
│   ├── appointment.routes.js
│   ├── service.routes.js
│   ├── specialist.routes.js
│   ├── product.routes.js
│   ├── sale.routes.js
│   └── blocked-slot.routes.js
├── utils/               # Utilidades
│   └── jwt.js
└── server.js           # Punto de entrada
```

### Arquitectura en Capas

```
┌─────────────────────────────────────┐
│         Routes Layer                │  ← Define endpoints
├─────────────────────────────────────┤
│      Middleware Layer               │  ← Autenticación, validación
├─────────────────────────────────────┤
│      Controllers Layer              │  ← Lógica de negocio
├─────────────────────────────────────┤
│      Prisma ORM Layer               │  ← Abstracción de BD
├─────────────────────────────────────┤
│      Database Layer                 │  ← PostgreSQL
└─────────────────────────────────────┘
```

### Endpoints Principales

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/auth/login` | Iniciar sesión |
| GET | `/api/services` | Listar servicios |
| POST | `/api/services` | Crear servicio |
| GET | `/api/appointments` | Listar citas |
| POST | `/api/appointments` | Crear cita |
| DELETE | `/api/appointments/:id` | Eliminar cita |
| GET | `/api/specialists` | Listar especialistas |
| GET | `/api/products` | Listar productos |
| POST | `/api/blocked-slots` | Crear horario bloqueado |

---

## 🗄️ Base de Datos - PostgreSQL

### Modelo Entidad-Relación

```
┌─────────────┐         ┌──────────────┐
│    User     │         │   Service    │
├─────────────┤         ├──────────────┤
│ id          │         │ id           │
│ email       │         │ name         │
│ password    │         │ description  │
│ name        │         │ price        │
│ role        │         │ duration     │
└─────────────┘         └──────────────┘
      │                        │
      │                        │
      │    ┌──────────────────┐│
      └────┤  Appointment     ├┘
           ├──────────────────┤
           │ id               │
           │ userId           │
           │ serviceId        │
           │ specialistId     │
           │ scheduledAt      │
           │ status           │
           │ notes            │
           └──────────────────┘
                  │
                  │
           ┌──────────────┐
           │  Specialist  │
           ├──────────────┤
           │ id           │
           │ name         │
           │ role         │
           └──────────────┘

┌──────────────────┐         ┌─────────────┐
│ BlockedTimeSlot  │         │   Product   │
├──────────────────┤         ├─────────────┤
│ id               │         │ id          │
│ specialistId     │         │ name        │
│ startsAt         │         │ description │
│ endsAt           │         │ price       │
└──────────────────┘         │ stock       │
                             └─────────────┘
                                   │
                                   │
                             ┌─────────────┐
                             │    Sale     │
                             ├─────────────┤
                             │ id          │
                             │ productId   │
                             │ quantity    │
                             │ total       │
                             └─────────────┘
```

### Relaciones

- **User** → **Appointment** (1:N) - Un usuario puede tener muchas citas
- **Service** → **Appointment** (1:N) - Un servicio puede estar en muchas citas
- **Specialist** → **Appointment** (1:N) - Un especialista puede tener muchas citas
- **Specialist** → **BlockedTimeSlot** (1:N) - Un especialista puede tener muchos horarios bloqueados
- **Product** → **Sale** (1:N) - Un producto puede tener muchas ventas

---

## 🔐 Seguridad

### Autenticación

- **JWT (JSON Web Tokens)**: Tokens firmados con clave secreta
- **bcrypt**: Hash de contraseñas con salt
- **Middleware de autenticación**: Verifica tokens en rutas protegidas

### Flujo de Autenticación

```
1. Usuario envía email + password
2. Backend verifica credenciales
3. Backend genera JWT token
4. Frontend almacena token (Secure Storage)
5. Frontend envía token en cada request
6. Backend valida token en middleware
7. Si válido → procesa request
8. Si inválido → retorna 401 Unauthorized
```

---

## 📡 Comunicación Frontend-Backend

### Protocolo

- **HTTP/REST**: Comunicación stateless
- **JSON**: Formato de intercambio de datos
- **CORS**: Habilitado para desarrollo

### Ejemplo de Request/Response

**Request:**
```http
POST /api/appointments
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json

{
  "serviceId": "abc123",
  "specialistId": "def456",
  "scheduledAt": "2024-05-15T10:00:00Z",
  "notes": "Primera cita"
}
```

**Response:**
```json
{
  "status": "success",
  "data": {
    "appointment": {
      "id": "xyz789",
      "serviceId": "abc123",
      "specialistId": "def456",
      "scheduledAt": "2024-05-15T10:00:00Z",
      "status": "CONFIRMED",
      "notes": "Primera cita"
    }
  }
}
```

---

## 🚀 Despliegue

### Desarrollo

- **Backend**: `npm start` → http://localhost:3000
- **Frontend**: `flutter run -d chrome --web-port 5565` → http://localhost:5565

### Producción (Recomendado)

**Backend:**
- Servidor Node.js (ej: AWS EC2, DigitalOcean)
- PostgreSQL en servidor dedicado
- Variables de entorno configuradas
- PM2 para gestión de procesos

**Frontend:**
- Build: `flutter build web`
- Deploy en: Netlify, Vercel, Firebase Hosting
- CDN para assets estáticos

---

## 📊 Escalabilidad

### Consideraciones

1. **Base de datos**: Índices en campos frecuentemente consultados
2. **Caché**: Redis para sesiones y datos frecuentes
3. **Load Balancer**: Nginx para múltiples instancias del backend
4. **CDN**: Cloudflare para assets del frontend
5. **Monitoreo**: Logs centralizados (Winston + ELK Stack)

---

## 🧪 Testing

### Backend
- **Unit Tests**: Jest para controladores
- **Integration Tests**: Supertest para endpoints
- **E2E Tests**: Postman/Newman

### Frontend
- **Unit Tests**: Flutter test para widgets
- **Integration Tests**: Flutter integration test
- **E2E Tests**: Selenium/Cypress

---

## 📝 Convenciones de Código

### Backend (JavaScript)
- **Naming**: camelCase para variables y funciones
- **Exports**: ES6 modules (import/export)
- **Async**: async/await para operaciones asíncronas
- **Error Handling**: try/catch con middleware global

### Frontend (Dart)
- **Naming**: camelCase para variables, PascalCase para clases
- **Widgets**: StatelessWidget cuando sea posible
- **State**: Provider para gestión de estado
- **Async**: Future/async/await

---

## 🔄 Versionado

- **Git**: Control de versiones
- **GitHub**: Repositorio remoto
- **Branches**: 
  - `master`: Código estable
  - `develop`: Desarrollo activo
  - `feature/*`: Nuevas funcionalidades

---

## 📚 Documentación Adicional

- **README.md**: Guía de instalación y uso
- **INSTRUCCIONES.txt**: Inicio rápido
- **RESUMEN_FINAL.txt**: Estado del proyecto
- **Código**: Comentarios inline cuando sea necesario

---

**Última actualización**: Mayo 2026
**Versión**: 1.0.0
**Autor**: Proyecto TFG DAM Grado Superior
