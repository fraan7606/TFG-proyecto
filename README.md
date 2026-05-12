# RosTecTic - Sistema de Gestión para Salón de Estética

**Proyecto TFG - DAM Grado Superior**

Sistema completo de gestión de citas, productos y especialistas para salones de estética, desarrollado con Flutter (frontend) y Node.js (backend).

---

## 📋 Índice

1. [Características](#características)
2. [Tecnologías Utilizadas](#tecnologías-utilizadas)
3. [Requisitos del Sistema](#requisitos-del-sistema)
4. [Estructura del Proyecto](#estructura-del-proyecto)
5. [Instalación y Configuración](#instalación-y-configuración)
6. [Guía de Lanzamiento](#guía-de-lanzamiento)
7. [Credenciales](#credenciales)
8. [Funcionalidades](#funcionalidades)

---

## ✨ Características

- **Panel de Administración**: Gestión completa del salón
- **Autenticación Segura**: Login con email y contraseña
- **Gestión de Citas**: Crear, ver y eliminar citas
- **Gestión de Servicios**: CRUD completo de servicios
- **Gestión de Productos**: Control de inventario y stock
- **Gestión de Especialistas**: Administración de perfiles
- **Bloqueo de Horarios**: Reservar horarios no disponibles
- **Reportes**: Estadísticas y análisis del salón
- **Multiplataforma**: Web, Android e iOS con Flutter

---

## Tecnologías Utilizadas

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

## Requisitos del Sistema

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

## Estructura del Proyecto

```
TFG-proyecto/
├── rostectic-backend/              # 🔧 Backend API (Node.js + Express)
│   ├── src/
│   │   ├── server.js              # Punto de entrada del servidor
│   │   ├── config/                # Configuraciones (DB)
│   │   ├── controllers/           # Controladores de rutas (7 archivos)
│   │   │   ├── appointment.controller.js
│   │   │   ├── auth.controller.js
│   │   │   ├── blocked-slot.controller.js
│   │   │   ├── product.controller.js
│   │   │   ├── sale.controller.js
│   │   │   ├── service.controller.js
│   │   │   └── specialist.controller.js
│   │   ├── middleware/            # Middlewares (autenticación)
│   │   ├── routes/                # Definición de rutas de la API (7 archivos)
│   │   └── utils/                 # Utilidades (JWT)
│   ├── prisma/
│   │   ├── schema.prisma          # Definición del esquema de BD
│   │   ├── migrations/            # Historial de migraciones
│   │   ├── seed.js                # Datos de prueba
│   │   └── seed_admin.js          # Usuario admin inicial
│   ├── package.json               # Dependencias del backend
│   ├── .env.example               # Ejemplo de variables de entorno
│   └── .env                       # Variables de entorno (NO commitear)
│
├── rostectic-app/                 # 📱 Frontend (Flutter Web)
│   ├── lib/
│   │   ├── main.dart              # Punto de entrada de Flutter
│   │   ├── config/
│   │   │   ├── theme.dart         # Tema y estilos
│   │   │   ├── routes.dart        # Rutas de navegación
│   │   │   └── api_config.dart    # Configuración de la API
│   │   ├── models/                # Modelos de datos (3 archivos)
│   │   ├── providers/             # Providers para gestión de estado (2 archivos)
│   │   ├── services/              # Servicios (API Service)
│   │   └── screens/               # Pantallas de la aplicación (14 archivos)
│   │       ├── auth/              # Login
│   │       ├── admin/             # Dashboard y gestión (7 pantallas)
│   │       └── user/              # Pantallas de usuario
│   ├── pubspec.yaml               # Dependencias de Flutter
│   ├── android/                   # Configuración Android
│   ├── ios/                       # Configuración iOS
│   └── web/                       # Configuración Web
│
├── LANZAR_FINAL.bat               # ⚡ Script para lanzar todo el proyecto
├── INSTRUCCIONES.txt              # 📄 Guía rápida de inicio
├── RESUMEN_FINAL.txt              # 📊 Estado completo del proyecto
└── README.md                      # 📖 Este archivo (documentación completa)
```

---

## Instalación y Configuración

> **📌 IMPORTANTE**: Esta guía está diseñada para instalar el proyecto desde cero en cualquier PC.

### Paso 1: Instalar Requisitos Previos

Antes de clonar el proyecto, asegúrate de tener instalado:

#### 1.1. Node.js y npm
1. Descarga Node.js v18+ desde [https://nodejs.org/](https://nodejs.org/)
2. Instala el archivo descargado
3. Verifica la instalación:
   ```bash
   node --version  # Debe mostrar v18.x.x o superior
   npm --version   # Debe mostrar v9.x.x o superior
   ```

#### 1.2. PostgreSQL
1. Descarga PostgreSQL v14+ desde [https://www.postgresql.org/download/](https://www.postgresql.org/download/)
2. Durante la instalación:
   - Anota la contraseña del usuario `postgres` (la necesitarás después)
   - Deja el puerto por defecto: 5432
   - Instala pgAdmin (viene incluido)
3. Verifica que PostgreSQL esté corriendo

#### 1.3. Flutter SDK
1. Descarga Flutter desde [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
2. Extrae el archivo en una ubicación (ej: `C:\src\flutter`)
3. Agrega Flutter al PATH del sistema
4. Verifica la instalación:
   ```bash
   flutter doctor  # Debe mostrar que Flutter está instalado
   ```

#### 1.4. Google Chrome
- Descarga e instala Chrome (necesario para Flutter Web)

### Paso 2: Clonar el Repositorio

```bash
git clone https://github.com/fraan7606/TFG-proyecto.git
cd TFG-proyecto
```

### Paso 3: Configurar la Base de Datos PostgreSQL

#### 3.1. Crear la Base de Datos

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

#### 3.2. Anotar Credenciales

Necesitarás:
- **Usuario**: postgres (o tu usuario personalizado)
- **Contraseña**: La que estableciste al instalar PostgreSQL
- **Host**: localhost
- **Puerto**: 5432
- **Nombre de BD**: rostectic

### Paso 4: Configurar el Backend

#### 4.1. Instalar Dependencias

```bash
cd rostectic-backend
npm install
```

Este comando instalará todas las dependencias necesarias (Express, Prisma, bcrypt, JWT, etc.).

#### 4.2. Configurar Variables de Entorno

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

**⚠️ IMPORTANTE**: 
- Cambia `TU_PASSWORD` por tu contraseña real de PostgreSQL
- Cambia `JWT_SECRET` por una clave segura aleatoria
- Las credenciales de SendGrid y Twilio son opcionales (no necesarias para el TFG)

#### 4.3. Ejecutar Migraciones de la Base de Datos

```bash
npx prisma migrate deploy
npx prisma generate
```

Estos comandos:
1. Conectan con PostgreSQL
2. Crean todas las tablas según el schema de Prisma
3. Generan el cliente de Prisma para interactuar con la BD

#### 4.4. Crear Usuario Administrador

```bash
node prisma/seed_admin.js
```

Este comando crea el usuario admin con credenciales:
- Email: `admin`
- Password: `admin123`

### Paso 5: Configurar el Frontend (Flutter)

#### 5.1. Instalar Dependencias

```bash
cd ../rostectic-app
flutter pub get
```

Este comando instalará todas las dependencias de Flutter (Provider, HTTP, etc.).

#### 5.2. Configurar URL del Backend

El archivo `lib/config/api_config.dart` ya está configurado correctamente:

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

## 🚀 Guía de Lanzamiento

### Opción 1: Lanzar Todo Automáticamente (Recomendado) ⚡

Simplemente ejecuta el archivo batch:

```bash
# Windows
LANZAR_FINAL.bat
```

Esto hará:
1. Limpia procesos previos
2. Inicia el **Backend** (Node.js + Express en puerto 3000)
3. Espera a que el backend esté listo
4. Inicia el **Frontend** (Flutter Web en puerto 5565)
5. Abre automáticamente en Chrome

**Salida esperada:**
```
╔════════════════════════════════════════════════════════════════╗
║                   ROSTECTIC - SISTEMA DE GESTIÓN              ║
║                    Proyecto TFG DAM Grado Superior            ║
╚════════════════════════════════════════════════════════════════╝

URLs DE ACCESO:
  Backend API:  http://localhost:3000/api
  Frontend:     http://localhost:5565

CREDENCIALES DE ADMIN:
  Email:    admin
  Password: admin123
```

### Opción 2: Lanzar Manualmente (Paso a Paso) 🔧

#### Terminal 1 - Backend

```bash
cd rostectic-backend
npm start
```

Verás:
```
Servidor RosTectic corriendo en http://localhost:3000
```

#### Terminal 2 - Frontend (Web)

```bash
cd rostectic-app
flutter run -d chrome --web-port 5565
```

Verás:
```
Launching lib/main.dart on Chrome in debug mode...
Built build/web
```

---

## 🔐 Credenciales

### Admin (Panel de Control)
```
Email:    admin
Password: admin123
```

**Acceso**: http://localhost:5565 → Iniciar Sesión

---

## 📱 Funcionalidades

### Panel de Administración (Centro de Control)
- **Reservar Cita**: Crear nuevas citas manualmente
- **Citas**: Ver todas las citas del sistema
- **Servicios**: Crear, editar y eliminar servicios
- **Productos**: Gestionar inventario y stock
- **Especialistas**: Administrar perfiles de especialistas
- **Horarios**: Bloquear horarios no disponibles
- **Reportes**: Ver estadísticas y análisis

### Características Técnicas
- ✅ Autenticación JWT segura
- ✅ Validación de datos en frontend y backend
- ✅ Manejo de errores robusto
- ✅ Interfaz responsive y moderna
- ✅ Base de datos relacional con Prisma ORM
- ✅ API REST documentada
- ✅ Estado management con Provider

---

## Verificación

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

## Solución de Problemas Comunes

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

## Comandos Útiles

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

## 📊 Estado del Proyecto

### ✅ Completado
- [x] Estructura del proyecto
- [x] Configuración de base de datos PostgreSQL
- [x] Esquema de Prisma ORM
- [x] Servidor Express funcional
- [x] Configuración de Flutter Web
- [x] Sistema de autenticación JWT
- [x] Gestión de Citas (CRUD)
- [x] Gestión de Servicios (CRUD)
- [x] Gestión de Productos (CRUD)
- [x] Gestión de Especialistas (CRUD)
- [x] Bloqueo de Horarios (CRUD)
- [x] Panel de Reportes y Estadísticas
- [x] Dashboard mejorado
- [x] Documentación completa
- [x] Scripts de lanzamiento automatizado
- [x] Subida a GitHub

---

## Licencia

Este proyecto está bajo la Licencia MIT.

---

## Autor

Proyecto desarrollado como Trabajo de Fin de Grado (TFG)

---

## Soporte

Si encuentras algún problema:
1. Verifica que todos los requisitos estén instalados
2. Revisa la sección de Solución de Problemas
3. Asegúrate de que PostgreSQL está corriendo
4. Verifica los logs en las terminales

---

**¡Listo! Ahora tienes RosTectic funcionando en tu máquina. **

