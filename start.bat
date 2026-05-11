@echo off
echo Matando procesos existentes...
taskkill /F /IM node.exe 2>nul
taskkill /F /IM chrome.exe 2>nul

echo.
echo Iniciando Backend en puerto 3000...
cd /d d:\Proyectos\TFG\rostectic-backend
start cmd /k npm start

echo.
echo Esperando 5 segundos...
timeout /t 5 /nobreak

echo.
echo Iniciando Frontend en puerto 5565...
cd /d d:\Proyectos\TFG\rostectic-app
start cmd /k flutter run -d chrome --web-port 5565

echo.
echo Proyecto lanzado!
echo Backend: http://localhost:3000
echo Frontend: http://localhost:5565
pause
