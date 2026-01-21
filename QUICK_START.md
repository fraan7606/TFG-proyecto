# RosTectic - Guía de Inicio Rápido

Este documento te guiará para poner en marcha el proyecto RosTectic completo (backend + frontend).

## 📦 Requisitos del Sistema

### Backend
- Node.js v18 o superior
- PostgreSQL v14 o superior
- npm o yarn

### Frontend
- Flutter SDK v3.16 o superior
- Chrome (para desarrollo web)
- Android Studio o VS Code

## 🚀 Instalación Paso a Paso

### 1. Configurar Base de Datos

```bash
# Instalar PostgreSQL si no lo tienes
# Windows: Descargar desde https://www.postgresql.org/download/windows/

# Crear base de datos
psql -U postgres
CREATE DATABASE rostectic;
\q
```

### 2. Configurar Backend

```bash
# Navegar a la carpeta del backend
cd rostectic-backend

# Instalar dependencias
npm install

# Copiar archivo de entorno
cp .env.example .env

# Editar .env con tus credenciales
# DATABASE_URL="postgresql://postgres:tu_password@localhost:5432/rostectic?schema=public"

# Ejecutar migraciones
npm run db:migrate

# Iniciar servidor
npm run dev
```

El backend estará corriendo en `http://localhost:3000`

### 3. Configurar Frontend Flutter

```bash
# Navegar a la carpeta del frontend
cd ../rostectic-app

# Instalar dependencias
flutter pub get

# Ejecutar en web
flutter run -d chrome

# O ejecutar en Android
flutter run -d android
```

## 🔧 Configuración de Variables de Entorno

### Backend (.env)

```env
DATABASE_URL="postgresql://postgres:password@localhost:5432/rostectic?schema=public"
PORT=3000
NODE_ENV=development
JWT_SECRET=tu_clave_secreta_muy_segura
JWT_EXPIRES_IN=7d

# Para notificaciones (configurar más adelante)
SENDGRID_API_KEY=
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
```

### Frontend (lib/config/api_config.dart)

Para desarrollo móvil, cambia `localhost` por la IP de tu computadora:

```dart
static const String baseUrl = 'http://192.168.1.X:3000/api';
```

## ✅ Verificar Instalación

### Backend
1. Abre `http://localhost:3000` en tu navegador
2. Deberías ver: `{"message": "RosTectic API - Sistema de gestión de citas"}`

### Frontend
1. La app debería abrir automáticamente
2. Verás la pantalla de splash seguida del login

## 📝 Próximos Pasos

1. **Implementar autenticación en el backend** (Fase 2)
2. **Conectar frontend con backend**
3. **Crear sistema de servicios**
4. **Implementar calendario de citas**

## 🐛 Solución de Problemas

### Backend no inicia
- Verifica que PostgreSQL esté corriendo
- Verifica las credenciales en `.env`
- Ejecuta `npm run db:migrate` nuevamente

### Flutter no encuentra dispositivos
- Ejecuta `flutter doctor` para ver problemas
- Para web: Asegúrate de tener Chrome instalado
- Para Android: Abre Android Studio y crea un emulador

### Error de CORS en frontend
- Verifica que `FRONTEND_URL` en `.env` coincida con la URL de tu app
- Para desarrollo móvil, usa la IP de tu computadora

## 📚 Documentación Adicional

- [README Backend](./rostectic-backend/README.md)
- [README Frontend](./rostectic-app/README.md)
- [Plan de Implementación](../.gemini/antigravity/brain/8b39f735-2eb9-4ad0-a0d7-5bb444acc056/implementation_plan.md)

## 🆘 Ayuda

Si encuentras problemas, revisa:
1. Los logs del backend en la terminal
2. Los logs de Flutter en la terminal
3. La consola del navegador (para web)
