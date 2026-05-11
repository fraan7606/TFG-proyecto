@echo off
setlocal enabledelayedexpansion

echo ========================================
echo    LANZANDO ROSTECTIC COMPLETO
echo ========================================
echo.

echo [1/4] Matando procesos existentes...
taskkill /F /IM node.exe 2>nul
taskkill /F /IM chrome.exe 2>nul
taskkill /F /IM dart.exe 2>nul
timeout /t 2 /nobreak >nul

echo [2/4] Iniciando Backend (puerto 3000)...
cd /d d:\Proyectos\TFG\rostectic-backend
start "Backend RosTectic" cmd /k npm start

echo [3/4] Esperando 5 segundos para que el backend inicie...
timeout /t 5 /nobreak

echo [4/4] Iniciando Frontend (puerto 5565)...
cd /d d:\Proyectos\TFG\rostectic-app
start "Frontend RosTectic" cmd /k flutter run -d chrome --web-port 5565

echo.
echo ========================================
echo    PROYECTO LANZADO
echo ========================================
echo.
echo Backend:  http://localhost:3000
echo Frontend: http://localhost:5565
echo.
echo Credenciales:
echo   Email: admin
echo   Password: admin123
echo.
pause
