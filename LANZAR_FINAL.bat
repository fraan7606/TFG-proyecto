@echo off
cls
echo ========================================
echo    LANZANDO ROSTECTIC - VERSION FINAL
echo ========================================
echo.

echo [1/4] Matando procesos existentes...
taskkill /F /IM node.exe 2>nul
taskkill /F /IM chrome.exe 2>nul
taskkill /F /IM dart.exe 2>nul
timeout /t 2 /nobreak >nul

echo [2/4] Iniciando Backend (puerto 3000)...
cd /d d:\Proyectos\TFG\rostectic-backend
start "Backend RosTectic" cmd /k "echo Backend iniciando... && npm start"

echo [3/4] Esperando 6 segundos...
timeout /t 6 /nobreak

echo [4/4] Iniciando Frontend (puerto 5565)...
cd /d d:\Proyectos\TFG\rostectic-app
start "Frontend RosTectic" cmd /k "echo Frontend iniciando... && flutter run -d chrome --web-port 5565"

echo.
echo ========================================
echo    PROYECTO LANZADO CORRECTAMENTE
echo ========================================
echo.
echo Backend:  http://localhost:3000
echo Frontend: http://localhost:5565
echo.
echo CAMBIOS IMPLEMENTADOS:
echo   [X] Zona horaria corregida (sin +2 horas)
echo   [X] Endpoint DELETE de citas agregado
echo   [X] Boton de borrar citas funcional
echo   [X] Estado "pending" removido
echo   [X] Recarga automatica despues de borrar
echo.
echo Credenciales:
echo   Email: admin
echo   Password: admin123
echo.
pause
