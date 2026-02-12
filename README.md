# RosTectic - Sistema de Gestión de Citas para Salón de Estética

Sistema completo de gestión de citas para salones de estética, desarrollado con Flutter (frontend) y Node.js (backend).

---

## 📋 Índice

1. [Características](#-características)
2. [Tecnologías Utilizadas](#-tecnologías-utilizadas)
3. [Requisitos del Sistema](#-requisitos-del-sistema)
4. [Estructura del Proyecto](#-estructura-del-proyecto)
5. [Instalación y Configuración](#-instalación-y-configuración)
6. [Guía de Lanzamiento](#-guía-de-lanzamiento)
7. [Verificación](#-verificación)

---

## 🚀 Características

- 📱 **Multiplataforma**: Web, Android e iOS con Flutter
- 🔐 **Autenticación dual**: Login con email o teléfono
- 📧 **Notificaciones inteligentes**: Email o SMS según método de registro
- 📅 **Gestión de citas**: Calendario interactivo para reservas
- ⭐ **Sistema de reseñas**: Valoraciones y comentarios
- 📦 **Gestión de inventario**: Control de productos y stock
- 📊 **Panel de administración**: Estadísticas y gestión completa

---

## 🛠️ Tecnologías Utilizadas

### Backend (Node.js)
El backend es una API REST desarrollada con las siguientes tecnologías:

| Tecnología | Versión | Propósito |
|-----------|---------|-----------|
| **Node.js** | v18+ | Entorno de ejecución JavaScript en el servidor |
| **Express.js** | v4.18+ | Framework web minimalista para crear APIs REST |
| **PostgreSQL** | v14+ | Sistema de gestión de base de datos relacional |
| **Prisma** | v5.7+ | ORM (Object-Relational Mapping) moderno para Node.js |
| **JWT** (jsonwebtoken) | v9.0+ | Autenticación basada en tokens |
| **bcrypt** | v5.1+ | Encriptación de contraseñas |
| **Express Validator** | v7.0+ | Validación de datos de entrada |
| **SendGrid** | v8.1+ | Servicio de envío de emails |
| **Twilio** | v4.20+ | Servicio de envío de SMS |
| **dotenv** | v16.3+ | Gestión de variables de entorno |
| **CORS** | v2.8+ | Manejo de peticiones cross-origin |
| **nodemon** | v3.0+ | Auto-reinicio del servidor en desarrollo |

### Frontend (Flutter)
La aplicación móvil y web está desarrollada con:

| Tecnología | Versión | Propósito |
|-----------|---------|-----------|
| **Flutter SDK** | v3.16+ | Framework multiplataforma de Google |
| **Dart** | v3.2+ | Lenguaje de programación optimizado para UI |
| **Provider** | Latest | Gestión de estado (State Management) |
| **HTTP** | Latest | Cliente HTTP para llamadas a la API |
| **Flutter Secure Storage** | Latest | Almacenamiento seguro de tokens y datos sensibles |
| **Table Calendar** | Latest | Widget de calendario interactivo |

---

## 💻 Requisitos del Sistema

### Para Desarrollo

#### 1. Node.js y npm
- **Node.js**: v18.0.0 o superior
- **npm**: v9.0.0 o superior (se instala con Node.js)
- **Descarga**: [https://nodejs.org/](https://nodejs.org/)

#### 2. PostgreSQL
- **PostgreSQL**: v14.0 o superior
- **Incluye**: pgAdmin (interfaz gráfica para gestionar la BD)
- **Descarga**: [https://www.postgresql.org/download/](https://www.postgresql.org/download/)
- **Puerto por defecto**: 5432

#### 3. Flutter SDK
- **Flutter SDK**: v3.16.0 o superior
- **Dart SDK**: Se incluye con Flutter (v3.2+)
- **Descarga**: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

#### 4. Navegador Web
- **Chrome**: Requerido para desarrollo web con Flutter
- Compatible con cualquier navegador moderno para uso final

#### 5. Editor de Código (Recomendado)
- **VS Code** con extensiones:
  - Flutter
  - Dart
  - Prisma
  - ES7+ React/Redux/React-Native snippets

O bien:
- **Android Studio** con plugins de Flutter y Dart

### Para Producción
- Servidor con Node.js v18+
- Servidor PostgreSQL v14+
- Build de Flutter para la plataforma objetivo (Web/Android/iOS)

---

## 📂 Estructura del Proyecto

```
TFG/
├── rostectic-backend/              # 🔧 Backend API (Node.js + Express)
│   ├── src/
│   │   ├── server.js              # Punto de entrada del servidor
│   │   ├── config/                # Configuraciones (DB, etc)
│   │   ├── controllers/           # Controladores de rutas
│   │   ├── middleware/            # Middlewares (autenticación, validación)
│   │   ├── routes/                # Definición de rutas de la API
│   │   ├── services/              # Lógica de negocio
│   │   └── utils/                 # Utilidades (JWT, email, SMS)
│   ├── prisma/
│   │   ├── schema.prisma          # Definición del esquema de BD
│   │   ├── migrations/            # Historial de migraciones
│   │   └── seed.js                # Datos iniciales
│   ├── package.json               # Dependencias del backend
│   ├── .env.example               # Ejemplo de variables de entorno
│   └── .env                       # Variables de entorno (NO commitear)
│
├── rostectic-app/                 # 📱 Frontend (Flutter)
│   ├── lib/
│   │   ├── main.dart              # Punto de entrada de Flutter
│   │   ├── config/
│   │   │   ├── theme.dart         # Tema y estilos
│   │   │   ├── routes.dart        # Rutas de navegación
│   │   │   └── api_config.dart    # Configuración de la API
│   │   ├── models/                # Modelos de datos (User, Appointment, etc)
│   │   ├── providers/             # Providers para gestión de estado
│   │   ├── services/              # Servicios (API, Storage, etc)
│   │   ├── screens/               # Pantallas de la aplicación
│   │   └── widgets/               # Widgets reutilizables
│   ├── assets/
│   │   ├── images/                # Imágenes y logos
│   │   └── icons/                 # Iconos personalizados
│   ├── pubspec.yaml               # Dependencias de Flutter
│   ├── android/                   # Configuración Android
│   ├── ios/                       # Configuración iOS
│   └── web/                       # Configuración Web
│
├── ejecutar_backend.bat           # Script para lanzar solo el backend
├── ejecutar_frontend.bat          # Script para lanzar solo el frontend
├── ejecutar_todo.bat              # Script para lanzar todo el proyecto
└── README.md                      # Este archivo
```

---

## 🚀 Instalación y Configuración

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/TU_USUARIO/rostectic.git
cd TFG
```

### Paso 2: Configurar la Base de Datos PostgreSQL

#### 2.1. Crear la Base de Datos

Abre pgAdmin o usa la terminal de PostgreSQL:

```sql
-- Opción 1: Usando pgAdmin
-- 1. Abre pgAdmin
-- 2. Click derecho en "Databases"
-- 3. Create > Database
-- 4. Nombre: rostectic
-- 5. Save

-- Opción 2: Usando psql en terminal
psql -U postgres
CREATE DATABASE rostectic;
\q
```

#### 2.2. Anotar Credenciales

Necesitarás:
- **Usuario**: postgres (o tu usuario personalizado)
- **Contraseña**: La que estableciste al instalar PostgreSQL
- **Host**: localhost
- **Puerto**: 5432
- **Nombre de BD**: rostectic

### Paso 3: Configurar el Backend

#### 3.1. Instalar Dependencias

```bash
cd rostectic-backend
npm install
```

#### 3.2. Configurar Variables de Entorno

Copia el archivo de ejemplo:

```bash
# Windows PowerShell
copy .env.example .env

# Linux/Mac
cp .env.example .env
```

Edita el archivo `.env` con tus credenciales:

```env
# Base de Datos PostgreSQL
DATABASE_URL="postgresql://postgres:TU_PASSWORD@localhost:5432/rostectic?schema=public"

# Servidor
PORT=3000
NODE_ENV=development

# Seguridad JWT
JWT_SECRET=clave_secreta_muy_segura_cambiala_en_produccion
JWT_EXPIRES_IN=7d

# Email (SendGrid) - Opcional por ahora
SENDGRID_API_KEY=tu_api_key_de_sendgrid
SENDGRID_FROM_EMAIL=noreply@rostectic.com

# SMS (Twilio) - Opcional por ahora
TWILIO_ACCOUNT_SID=tu_account_sid
TWILIO_AUTH_TOKEN=tu_auth_token
TWILIO_PHONE_NUMBER=+1234567890

# Frontend URL (para CORS)
FRONTEND_URL=http://localhost:8080
```

**⚠️ Importante**: 
- Cambia `TU_PASSWORD` por tu contraseña real de PostgreSQL
- Cambia `JWT_SECRET` por una clave segura aleatoria
- Las credenciales de SendGrid y Twilio son opcionales para empezar

#### 3.3. Ejecutar Migraciones de la Base de Datos

```bash
npm run db:migrate
```

Este comando:
1. Conecta con PostgreSQL
2. Crea todas las tablas según el schema de Prisma
3. Genera el cliente de Prisma para interactuar con la BD

#### 3.4. (Opcional) Poblar con Datos de Prueba

```bash
npm run db:seed
```

### Paso 4: Configurar el Frontend (Flutter)

#### 4.1. Instalar Dependencias

```bash
cd ../rostectic-app
flutter pub get
```

#### 4.2. Configurar URL del Backend

Edita el archivo `lib/config/api_config.dart`:

```dart
class ApiConfig {
  // Para desarrollo web (Chrome)
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Para desarrollo en Android/iOS (usa la IP de tu PC)
  // static const String baseUrl = 'http://192.168.1.X:3000/api';
  
  static const Duration timeout = Duration(seconds: 30);
}
```

**📝 Nota sobre localhost**:
- **Web (Chrome)**: Usa `http://localhost:3000/api`
- **Android/iOS**: No puedes usar `localhost`, debes usar la IP de tu PC:
  1. Abre CMD/PowerShell
  2. Ejecuta: `ipconfig`
  3. Busca tu dirección IPv4 (ej: 192.168.1.5)
  4. Usa: `http://192.168.1.5:3000/api`

---

## 🏃 Guía de Lanzamiento

Tienes **3 opciones** para lanzar el proyecto:

### Opción 1: Lanzar Todo Automáticamente (Recomendado) ⚡

Simplemente ejecuta el archivo batch:

```bash
# Windows
ejecutar_todo.bat
```

Esto hará:
1. Abre una ventana para el **Backend** (Node.js en puerto 3000)
2. Espera 5 segundos
3. Abre otra ventana para el **Frontend** (Flutter en Chrome)

### Opción 2: Lanzar Manualmente (Paso a Paso) 🔧

#### Terminal 1 - Backend

```bash
cd rostectic-backend
npm run dev
```

Salida esperada:
```
🚀 Servidor RosTectic corriendo en http://localhost:3000
📝 Entorno: development
```

#### Terminal 2 - Frontend (Web)

```bash
cd rostectic-app
flutter run -d chrome
```

Salida esperada:
```
Launching lib/main.dart on Chrome in debug mode...
✓ Built build/web
```

#### Frontend (Móvil - Android)

```bash
cd rostectic-app
flutter run -d android
```

O para iOS (solo Mac):

```bash
flutter run -d ios
```

### Opción 3: Scripts Individuales 📦

```bash
# Solo Backend
ejecutar_backend.bat

# Solo Frontend (Windows)
ejecutar_frontend.bat

# Solo Frontend (Web)
ejecutar_frontend_web.bat
```

---

## ✅ Verificación

### Backend Funcionando

1. **Abre tu navegador**
2. **Navega a**: http://localhost:3000
3. **Deberías ver**:
   ```json
   {
     "message": "RosTectic API - Sistema de gestión de citas"
   }
   ```

### Frontend Funcionando

1. **Chrome se abrirá automáticamente**
2. **Verás la aplicación RosTectic** en la pantalla de bienvenida
3. **En la terminal** verás:
   ```
   Flutter run key commands.
   r Hot reload.
   R Hot restart.
   ```

### Verificar Conexión Frontend-Backend

1. En la app, intenta registrarte o iniciar sesión
2. Verifica en la terminal del backend que lleguen las peticiones:
   ```
   POST /api/auth/register 201 - 123ms
   ```

---

## 🐛 Solución de Problemas Comunes

### Backend

**Error: "DATABASE_URL" no válido**
- Verifica que el archivo `.env` existe en `rostectic-backend/`
- Asegúrate de usar las credenciales correctas de PostgreSQL
- Verifica que PostgreSQL está corriendo

**Error: "Port 3000 is already in use"**
- Cierra el proceso que usa el puerto 3000
- O cambia el puerto en `.env`: `PORT=3001`

**Error: "prisma not found"**
- Ejecuta: `npm install` dentro de `rostectic-backend/`

### Frontend

**Error: "Flutter SDK not found"**
- Verifica la instalación: `flutter doctor`
- Asegúrate de tener Flutter en el PATH

**Error: "Chrome device not found"**
- Instala Chrome
- Verifica con: `flutter devices`

**Error de conexión con backend**
- Verifica que el backend esté corriendo
- Revisa la URL en `lib/config/api_config.dart`
- Si usas móvil, usa la IP de tu PC, no `localhost`

**Error: "Disk full" o "Not enough space"**
- El proyecto usa carpeta `temp/` en el disco D:
- Libera espacio o cambia la ruta en los archivos `.bat`

---

## 📚 Comandos Útiles

### Backend

```bash
# Iniciar servidor desarrollo
npm run dev

# Iniciar servidor producción
npm start

# Ver base de datos en interfaz gráfica
npm run db:studio

# Crear nueva migración
npm run db:migrate

# Reiniciar base de datos
npx prisma migrate reset
```

### Frontend

```bash
# Listar dispositivos disponibles
flutter devices

# Ejecutar en Chrome
flutter run -d chrome

# Ejecutar en Android
flutter run -d android

# Build para producción web
flutter build web

# Limpiar caché
flutter clean
flutter pub get
```

---

## 🎯 Estado del Proyecto

### ✅ Completado
- [x] Estructura del proyecto
- [x] Configuración de base de datos
- [x] Esquema de Prisma
- [x] Servidor Express funcional
- [x] Configuración de Flutter
- [x] Sistema de autenticación JWT
- [x] Scripts de lanzamiento automatizado

### 🚧 En Desarrollo
- [ ] Sistema completo de autenticación (frontend + backend)
- [ ] Gestión de citas
- [ ] Calendario interactivo
- [ ] Sistema de notificaciones

### 📋 Pendiente
- [ ] Sistema de reseñas
- [ ] Panel de administración
- [ ] Gestión de inventario
- [ ] Despliegue en producción

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.

---

## 👤 Autor

Proyecto desarrollado como Trabajo de Fin de Grado (TFG)

---

## 📞 Soporte

Si encuentras algún problema:
1. Verifica que todos los requisitos estén instalados
2. Revisa la sección de Solución de Problemas
3. Asegúrate de que PostgreSQL está corriendo
4. Verifica los logs en las terminales

---

**¡Listo! Ahora tienes RosTectic funcionando en tu máquina. 🎉**
