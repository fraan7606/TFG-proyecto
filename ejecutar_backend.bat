@echo off
echo Iniciando Backend (Node.js)...

:: Redirigir temporales al disco D para evitar error de espacio en C
set "TEMP=D:\Proyectos\TFG\temp"
set "TMP=D:\Proyectos\TFG\temp"
if not exist "%TEMP%" mkdir "%TEMP%"

cd rostectic-backend
npm run dev
pause
