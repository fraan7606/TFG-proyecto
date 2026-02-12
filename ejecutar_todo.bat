@echo off
echo Lanzando el sistema RosTectic completo...

:: Redirigir temporales al disco D para evitar error de espacio en C
set "TEMP=D:\Proyectos\TFG\temp"
set "TMP=D:\Proyectos\TFG\temp"
if not exist "%TEMP%" mkdir "%TEMP%"

start "Backend" cmd /k "set TEMP=D:\Proyectos\TFG\temp&& set TMP=D:\Proyectos\TFG\temp&& cd rostectic-backend && npm run dev"
timeout /t 5
start "Frontend" cmd /k "set TEMP=D:\Proyectos\TFG\temp&& set TMP=D:\Proyectos\TFG\temp&& cd rostectic-app && flutter run -d chrome"

echo.
echo ==================================================
echo El Backend y el Frontend se estan iniciando en 
echo ventanas separadas (Temp redirigido al disco D).
echo Puedes cerrar esta ventana.
echo ==================================================
timeout /t 10
exit
