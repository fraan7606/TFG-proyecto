@echo off
echo Iniciando Flutter App (Modo Windows)...

:: Redirigir temporales al disco D para evitar error de espacio en C
set "TEMP=D:\Proyectos\TFG\temp"
set "TMP=D:\Proyectos\TFG\temp"
if not exist "%TEMP%" mkdir "%TEMP%"

cd rostectic-app
flutter run -d windows
pause
