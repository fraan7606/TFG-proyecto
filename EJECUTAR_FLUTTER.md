# 🚀 Cómo Ejecutar la App Flutter en Web

## ⚠️ Problema Detectado

Flutter no está en el PATH de PowerShell. Necesitas ejecutarlo desde el Símbolo del Sistema (CMD) donde sí funciona.

---

## ✅ Solución: Usar CMD (Símbolo del Sistema)

### Opción 1: Desde CMD (Recomendado)

1. **Abrir Símbolo del Sistema**
   - Presiona `Win + R`
   - Escribe `cmd`
   - Presiona Enter

2. **Navegar a la carpeta del proyecto**
   ```cmd
   cd C:\Users\elect\TFG\rostectic-app
   ```

3. **Instalar dependencias**
   ```cmd
   flutter pub get
   ```

4. **Ejecutar la app en Chrome**
   ```cmd
   flutter run -d chrome
   ```

---

### Opción 2: Desde VS Code Terminal

1. **Abrir VS Code**
   - Abre la carpeta `C:\Users\elect\TFG\rostectic-app`

2. **Cambiar terminal a CMD**
   - En VS Code, abre la terminal (`` Ctrl + ` ``)
   - Click en la flecha hacia abajo junto a "PowerShell"
   - Selecciona "Command Prompt" o "CMD"

3. **Ejecutar comandos**
   ```cmd
   flutter pub get
   flutter run -d chrome
   ```

---

### Opción 3: Agregar Flutter al PATH de PowerShell

Si quieres usar PowerShell, necesitas agregar Flutter al PATH:

1. **Encontrar la ruta de Flutter**
   - Abre CMD y ejecuta:
   ```cmd
   where flutter
   ```
   - Copia la ruta (ejemplo: `C:\src\flutter\bin`)

2. **Agregar al PATH de PowerShell**
   - Abre PowerShell como Administrador
   - Ejecuta:
   ```powershell
   $env:PATH += ";C:\src\flutter\bin"
   ```
   - Reemplaza `C:\src\flutter\bin` con tu ruta real

3. **Verificar**
   ```powershell
   flutter --version
   ```

---

## 🎯 Comandos Principales de Flutter

### Instalar dependencias
```bash
flutter pub get
```

### Ejecutar en web (Chrome)
```bash
flutter run -d chrome
```

### Ver dispositivos disponibles
```bash
flutter devices
```

### Limpiar proyecto
```bash
flutter clean
```

### Hot Reload (mientras la app corre)
- Presiona `r` en la terminal

### Hot Restart (reinicio completo)
- Presiona `R` en la terminal

### Detener la app
- Presiona `q` en la terminal

---

## 📱 Lo que verás al ejecutar

1. **Primera vez**: Flutter descargará dependencias (puede tardar 1-2 minutos)

2. **Compilación**: Verás mensajes como:
   ```
   Launching lib\main.dart on Chrome in debug mode...
   Building application for the web...
   ```

3. **Chrome se abrirá automáticamente** con la app

4. **Verás la pantalla de Splash** (logo RosTectic) por 2 segundos

5. **Luego la pantalla de Login** con:
   - Toggle Email/Teléfono
   - Campos de login
   - Botón de registro

---

## 🐛 Solución de Problemas

### Error: "flutter: command not found"
- Usa CMD en lugar de PowerShell
- O agrega Flutter al PATH

### Error: "No devices found"
- Asegúrate de tener Chrome instalado
- Ejecuta: `flutter devices` para ver dispositivos disponibles

### Error al compilar
- Ejecuta: `flutter clean`
- Luego: `flutter pub get`
- Intenta de nuevo: `flutter run -d chrome`

### La app no se ve bien
- Presiona `F12` en Chrome para abrir DevTools
- Cambia el tamaño de la ventana
- La app es responsive y se adapta

---

## 🎨 Características de la App (Fase 1)

Lo que podrás ver:

✅ **Splash Screen**
- Logo del salón
- Gradiente rosa/púrpura
- Animación de carga

✅ **Login Screen**
- Toggle entre Email y Teléfono
- Validación de formularios
- Diseño moderno con tema rosa

✅ **Register Screen**
- Registro con email o teléfono
- Confirmación de contraseña
- Validaciones

✅ **Home Screen** (placeholder)
- Acciones rápidas
- Sección de próximas citas

---

## 🔄 Desarrollo con Hot Reload

Una vez que la app esté corriendo:

1. **Edita cualquier archivo** (por ejemplo, cambia un texto)
2. **Guarda el archivo** (`Ctrl + S`)
3. **Presiona `r`** en la terminal
4. **Los cambios aparecen INSTANTÁNEAMENTE** en Chrome

¡No necesitas reiniciar la app! 🚀

---

## 📝 Próximos Pasos

Después de probar la app:

1. **Familiarízate con la interfaz**
2. **Prueba el Hot Reload** cambiando textos o colores
3. **Revisa el código** en `lib/screens/`
4. **Cuando estés listo**, implementaremos la autenticación real (Fase 2)

---

## ❓ ¿Necesitas Ayuda?

Si tienes algún error, cópiame el mensaje completo y te ayudo a solucionarlo.

**¡Disfruta probando tu app!** 🎉
