@echo off
setlocal enabledelayedexpansion

echo ========================================
echo    COMPILANDO Y LANZANDO ROSTECTIC
echo ========================================
echo.

echo [1/5] Matando procesos existentes...
taskkill /F /IM node.exe 2>nul
taskkill /F /IM chrome.exe 2>nul
taskkill /F /IM dart.exe 2>nul
timeout /t 2 /nobreak >nul

echo [2/5] Compilando Flutter...
cd /d d:\Proyectos\TFG\rostectic-app
call flutter clean >nul 2>&1
call flutter pub get >nul 2>&1

echo [3/5] Iniciando Backend (puerto 3000)...
cd /d d:\Proyectos\TFG\rostectic-backend
start "Backend RosTectic" cmd /k npm start

echo [4/5] Esperando 5 segundos para que el backend inicie...
timeout /t 5 /nobreak

echo [5/5] Iniciando Frontend (puerto 5565)...
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
echo Cambios realizados:
echo   - Zona horaria corregida (sin +2 horas)
echo   - Boton de borrar citas agregado
echo   - Estado "pending" removido
echo.
pause
