# 🚀 Lanzar RosTectic

## Opción 1: Script automático (Recomendado)
Ejecuta en PowerShell:
```powershell
d:\Proyectos\TFG\start.bat
```

## Opción 2: Manual en dos terminales

### Terminal 1 - Backend
```powershell
cd d:\Proyectos\TFG\rostectic-backend
npm start
```
Espera a ver: `🚀 Servidor RosTectic corriendo en http://localhost:3000`

### Terminal 2 - Frontend
```powershell
cd d:\Proyectos\TFG\rostectic-app
flutter run -d chrome --web-port 5565
```

## Credenciales de prueba
- **Email:** admin
- **Contraseña:** admin123

## URLs
- Backend: http://localhost:3000
- Frontend: http://localhost:5565

## Funcionalidades del Dashboard (6 tarjetas)
1. 🔵 Reservar Cita
2. 🟢 Ver Citas
3. 🟣 Gestionar Servicios
4. 🟠 Gestionar Productos
5. 🔵 Registrar Ventas
6. 🔴 Bloquear Horarios
