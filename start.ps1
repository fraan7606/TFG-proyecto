# Script para lanzar el proyecto completo

Write-Host "🔴 Matando procesos Node existentes..." -ForegroundColor Yellow
taskkill /F /IM node.exe 2>$null

Write-Host "🔴 Matando procesos Chrome existentes..." -ForegroundColor Yellow
taskkill /F /IM chrome.exe 2>$null

Write-Host "🟢 Iniciando Backend..." -ForegroundColor Green
cd d:\Proyectos\TFG\rostectic-backend
Start-Process powershell -ArgumentList "-NoExit", "-Command", "npm start"

Write-Host "⏳ Esperando 5 segundos para que el backend inicie..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

Write-Host "🟢 Iniciando Frontend..." -ForegroundColor Green
cd d:\Proyectos\TFG\rostectic-app
Start-Process powershell -ArgumentList "-NoExit", "-Command", "flutter run -d chrome --web-port 5565"

Write-Host "✅ Proyecto lanzado!" -ForegroundColor Green
Write-Host "Backend: http://localhost:3000" -ForegroundColor Cyan
Write-Host "Frontend: http://localhost:5565" -ForegroundColor Cyan
