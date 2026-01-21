# RosTectic App

Aplicación móvil y web para RosTectic - Sistema de gestión de citas para salón de estética.

## 🚀 Tecnologías

- **Flutter** v3.16+
- **Dart** v3.2+
- **Provider** - State management
- **HTTP** - Cliente HTTP
- **Flutter Secure Storage** - Almacenamiento seguro
- **Table Calendar** - Calendario interactivo

## 📋 Requisitos Previos

1. **Flutter SDK** v3.16 o superior
2. **Dart SDK** v3.2 o superior
3. **Android Studio** o **VS Code** con extensiones de Flutter
4. **Chrome** (para desarrollo web)

## 🔧 Instalación

### 1. Verificar instalación de Flutter

```bash
flutter doctor
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar Backend URL

Edita `lib/config/api_config.dart` y actualiza la URL del backend:

```dart
static const String baseUrl = 'http://tu-ip:3000/api';
```

**Nota**: Para desarrollo móvil, usa la IP de tu computadora en lugar de `localhost`.

## 🏃 Ejecutar la Aplicación

### Web

```bash
flutter run -d chrome
```

### Android

```bash
flutter run -d android
```

### iOS (solo en macOS)

```bash
flutter run -d ios
```

### Listar dispositivos disponibles

```bash
flutter devices
```

## 📁 Estructura del Proyecto

```
rostectic_app/
├── lib/
│   ├── main.dart                 # Punto de entrada
│   ├── config/
│   │   ├── theme.dart           # Tema y colores
│   │   ├── routes.dart          # Rutas de navegación
│   │   └── api_config.dart      # Configuración API
│   ├── models/
│   │   └── user_model.dart      # Modelo de usuario
│   ├── providers/
│   │   └── auth_provider.dart   # Provider de autenticación
│   ├── services/
│   │   └── api_service.dart     # Servicio HTTP
│   ├── screens/
│   │   ├── splash_screen.dart   # Pantalla de inicio
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   └── home/
│   │       └── home_screen.dart
│   └── widgets/                  # Widgets reutilizables
├── assets/
│   ├── images/
│   └── icons/
└── pubspec.yaml
```

## 🎨 Características Implementadas

### ✅ Fase 1: Autenticación
- [x] Pantalla de splash
- [x] Login con email
- [x] Login con teléfono
- [x] Registro con email
- [x] Registro con teléfono
- [x] Validación de formularios
- [x] Gestión de estado con Provider

### 🚧 Próximas Características
- [ ] Listado de servicios
- [ ] Calendario de citas
- [ ] Reserva de citas
- [ ] Historial de citas
- [ ] Sistema de notificaciones
- [ ] Valoraciones y reseñas
- [ ] Perfil de usuario

## 🔐 Autenticación

La app soporta dos métodos de autenticación:
- **Email + Contraseña**: Notificaciones por email
- **Teléfono + Contraseña**: Notificaciones por SMS

El método de notificación se determina automáticamente según el método de registro.

## 🛠️ Scripts Útiles

```bash
# Ejecutar en modo debug
flutter run

# Ejecutar en modo release
flutter run --release

# Limpiar proyecto
flutter clean

# Actualizar dependencias
flutter pub upgrade

# Generar APK (Android)
flutter build apk

# Generar app web
flutter build web
```

## 📱 Testing

```bash
# Ejecutar tests
flutter test

# Ejecutar tests con cobertura
flutter test --coverage
```

## 🌐 Desarrollo Web

Para desarrollo web, la app se ejecuta en `http://localhost:8080` por defecto.

Asegúrate de que el backend permita CORS desde esta URL.

## 📝 Notas de Desarrollo

- **Hot Reload**: Presiona `r` en la terminal durante el desarrollo
- **Hot Restart**: Presiona `R` en la terminal
- **Quit**: Presiona `q` en la terminal

## 🎨 Tema y Diseño

El tema está configurado con colores elegantes para un salón de estética:
- **Primary**: Rosa elegante (#E91E63)
- **Secondary**: Púrpura (#9C27B0)
- **Accent**: Rosa vibrante (#FF4081)

Fuente: **Poppins** (Google Fonts)

## 📄 Licencia

MIT
