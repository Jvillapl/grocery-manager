# 🚀 Instrucciones para subir a GitHub

## Opción 1: Crear repositorio desde GitHub (Recomendado)

### 1. Crear repositorio en GitHub
1. Ve a: https://github.com/new
2. Nombre del repositorio: `grocery-manager`
3. Descripción: `Flutter app for intelligent grocery shopping management`
4. **IMPORTANTE**: Selecciona "Private" si quieres que sea privado
5. **NO** marques "Add a README file" (ya tenemos uno)
6. Haz clic en "Create repository"

### 2. Conectar tu proyecto local
Copia y ejecuta estos comandos en tu terminal:

```bash
# Añadir el repositorio remoto (reemplaza TU_USUARIO por tu usuario de GitHub)
git remote add origin https://github.com/TU_USUARIO/grocery-manager.git

# Cambiar el nombre de la rama principal
git branch -M main

# Subir el código
git push -u origin main
```

## Opción 2: GitHub CLI (si tienes gh instalado)

```bash
# Crear repositorio directamente desde terminal
gh repo create grocery-manager --private --description "Flutter app for intelligent grocery shopping management"

# Subir el código
git push -u origin main
```

## Opción 3: GitHub Desktop (Interfaz gráfica)

1. Descargar GitHub Desktop: https://desktop.github.com/
2. Instalar y hacer login
3. File → Add local repository
4. Seleccionar: `D:\Despensa\grocery_manager`
5. Publish repository → Elegir nombre y privacidad

## ✅ Verificar que se subió correctamente

Después de ejecutar cualquiera de las opciones anteriores:
1. Ve a tu repositorio en GitHub
2. Deberías ver todos los archivos
3. El README.md se mostrará en la página principal

## 🔒 Nota de Seguridad

Los archivos sensibles ya están en `.gitignore`:
- `lib/firebase_options.dart` (contendrá claves API)
- `android/app/google-services.json` (configuración Firebase Android)
- `ios/Runner/GoogleService-Info.plist` (configuración Firebase iOS)

## 🎯 Próximos pasos después de subir

1. **Configurar Firebase** siguiendo el README
2. **Configurar GitHub Actions** para CI/CD
3. **Añadir issues y milestones** para tracking
4. **Invitar colaboradores** si es necesario

---

**¿Necesitas ayuda con algún paso?** ¡Dime y te ayudo!