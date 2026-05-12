@echo off
cls
echo.
echo ========================================
echo    ROSTECTIC - SISTEMA DE GESTION
echo    Proyecto TFG DAM Grado Superior
echo ========================================
echo.

echo [1/4] Limpiando procesos previos...
taskkill /F /IM node.exe 2>nul
taskkill /F /IM chrome.exe 2>nul
taskkill /F /IM dart.exe 2>nul
timeout /t 2 /nobreak >nul

echo [2/4] Iniciando Backend (Express + Prisma + PostgreSQL)...
echo       Puerto: 3000
cd /d d:\Proyectos\TFG\rostectic-backend
start "Backend RosTectic" cmd /k "npm start"

echo [3/4] Esperando inicializacion del backend...
timeout /t 6 /nobreak

echo [4/4] Iniciando Frontend (Flutter Web)...
echo       Puerto: 5565
cd /d d:\Proyectos\TFG\rostectic-app
start "Frontend RosTectic" cmd /k "flutter run -d chrome --web-port 5565"

echo.
echo ========================================
echo    PROYECTO INICIADO CORRECTAMENTE
echo ========================================
echo.
echo URLs DE ACCESO:
echo   Backend API:  http://localhost:3000/api
echo   Frontend:     http://localhost:5565
echo.
echo CREDENCIALES DE ADMIN:
echo   Email:    admin
echo   Password: admin123
echo.
echo FUNCIONALIDADES PRINCIPALES:
echo   [+] Gestion de Citas (Crear, Ver, Eliminar)
echo   [+] Gestion de Servicios (CRUD)
echo   [+] Gestion de Productos (CRUD)
echo   [+] Gestion de Especialistas (CRUD)
echo   [+] Bloqueo de Horarios
echo   [+] Reportes y Estadisticas
echo.
echo TECNOLOGIAS:
echo   Frontend:  Flutter Web
echo   Backend:   Node.js + Express
echo   BD:        PostgreSQL + Prisma ORM
echo.
pause
