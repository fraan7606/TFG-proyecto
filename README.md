# RosTectic - Sistema de Gestión de Citas para Salón de Estética

Sistema completo de gestión de citas para salones de estética, desarrollado con Flutter (frontend) y Node.js (backend).

## 🚀 Características

- 📱 **Multiplataforma**: Web, Android e iOS con Flutter
- 🔐 **Autenticación dual**: Login con email o teléfono
- 📧 **Notificaciones inteligentes**: Email o SMS según método de registro
- 📅 **Gestión de citas**: Calendario interactivo para reservas
- ⭐ **Sistema de reseñas**: Valoraciones y comentarios
- 📦 **Gestión de inventario**: Control de productos y stock
- 📊 **Panel de administración**: Estadísticas y gestión completa

## 📂 Estructura del Proyecto

```
TFG/
├── rostectic-backend/     # Backend API (Node.js + Express + PostgreSQL)
├── rostectic-app/         # Frontend (Flutter)
├── QUICK_START.md         # Guía de inicio rápido
├── FLUTTER_EXPLICACION.md # Guía completa de Flutter
└── BACKEND_EXPLICACION.md # Guía completa del Backend
```

## 🛠️ Stack Tecnológico

### Backend
- **Node.js** + **Express** - API REST
- **PostgreSQL** - Base de datos
- **Prisma** - ORM
- **JWT** - Autenticación
- **SendGrid** - Emails
- **Twilio** - SMS

### Frontend
- **Flutter** - Framework multiplataforma
- **Dart** - Lenguaje de programación
- **Provider** - Gestión de estado
- **HTTP** - Cliente REST

## 🚀 Inicio Rápido

### Requisitos Previos
- Node.js v18+
- PostgreSQL v14+
- Flutter SDK v3.16+

### Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/TU_USUARIO/rostectic.git
cd rostectic
```

2. **Configurar Backend**
```bash
cd rostectic-backend
npm install
cp .env.example .env
# Editar .env con tus credenciales
npm run db:migrate
npm run dev
```

3. **Configurar Frontend**
```bash
cd ../rostectic-app
flutter pub get
flutter run -d chrome
```

Para instrucciones detalladas, consulta [QUICK_START.md](./QUICK_START.md)

## 📚 Documentación

- **[QUICK_START.md](./QUICK_START.md)** - Guía de instalación paso a paso
- **[FLUTTER_EXPLICACION.md](./FLUTTER_EXPLICACION.md)** - Guía completa de Flutter
- **[BACKEND_EXPLICACION.md](./BACKEND_EXPLICACION.md)** - Guía completa del Backend
- **[rostectic-backend/README.md](./rostectic-backend/README.md)** - Documentación del Backend
- **[rostectic-app/README.md](./rostectic-app/README.md)** - Documentación del Frontend

## 🎯 Roadmap

### ✅ Fase 1: Configuración Inicial (Completada)
- [x] Estructura del proyecto
- [x] Configuración de base de datos
- [x] Diseño de esquema
- [x] Configuración de Flutter

### 🚧 Fase 2: Autenticación (En Progreso)
- [ ] Registro con email/teléfono
- [ ] Login con email/teléfono
- [ ] Gestión de sesiones JWT
- [ ] Integración frontend-backend

### 📋 Próximas Fases
- Gestión de servicios
- Sistema de citas con calendario
- Notificaciones (Email/SMS)
- Historial de citas
- Sistema de valoraciones
- Gestión de inventario
- Panel de estadísticas

## 🤝 Contribuir

Este es un proyecto de TFG (Trabajo Final de Grado). Las contribuciones son bienvenidas.

## 📄 Licencia

MIT

## 👨‍💻 Autor

Desarrollado como Trabajo Final de Grado

---

**RosTectic** - Gestión profesional para tu salón de estética 💅✨
