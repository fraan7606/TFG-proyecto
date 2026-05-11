@echo off
cls
echo ========================================
echo    ROSTECTIC - SISTEMA COMPLETO
echo ========================================
echo.

echo [1/4] Limpiando procesos...
taskkill /F /IM node.exe 2>nul
taskkill /F /IM chrome.exe 2>nul
taskkill /F /IM dart.exe 2>nul
timeout /t 2 /nobreak >nul

echo [2/4] Iniciando Backend (puerto 3000)...
cd /d d:\Proyectos\TFG\rostectic-backend
start "Backend RosTectic" cmd /k "color 0A && echo === BACKEND ROSTECTIC === && npm start"

echo [3/4] Esperando 6 segundos...
timeout /t 6 /nobreak

echo [4/4] Iniciando Frontend (puerto 5565)...
cd /d d:\Proyectos\TFG\rostectic-app
start "Frontend RosTectic" cmd /k "color 0B && echo === FRONTEND ROSTECTIC === && flutter run -d chrome --web-port 5565"

echo.
echo ========================================
echo    SISTEMA LANZADO
echo ========================================
echo.
echo Backend:  http://localhost:3000
echo Frontend: http://localhost:5565
echo.
echo PROBLEMAS RESUELTOS:
echo   [X] Boton continuar ahora funciona (4 pasos)
echo   [X] Bloqueo de horas por especialista especifico
echo   [X] Bloqueo de horas por fecha especifica
echo   [X] Zona horaria corregida
echo   [X] Borrar citas funcional
echo.
echo COMO FUNCIONA EL BLOQUEO:
echo   - Si Juan tiene cita a las 10:00 (1h servicio)
echo   - Solo se bloquea 10:00-11:00 para Juan
echo   - Maria puede tener cita a las 10:00
echo   - Juan puede tener otra cita otro dia a las 10:00
echo.
pause
