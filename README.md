# grocery_manager

A new Flutter project.

## Getting Started

# Grocery Manager 🛒

Una aplicación Flutter para la gestión inteligente de compras y despensa con alertas de vencimiento y sugerencias de menús.

## 🚀 Características

- **Gestión de Inventario**: Registra tus compras y mantén un inventario actualizado
- **Alertas de Vencimiento**: Recibe notificaciones push cuando los productos estén próximos a vencer
- **Sugerencias de Menús**: Obtén recomendaciones de comidas basadas en tu inventario actual
- **Multi-usuario**: Cada usuario tiene su propio inventario y datos
- **Multiplataforma**: Funciona en Android e iOS

## 🛠️ Tecnologías

- **Frontend**: Flutter 3.13+
- **Backend**: Firebase (Auth, Firestore, Cloud Functions, FCM)
- **Estado**: Provider
- **Autenticación**: Firebase Auth
- **Base de datos**: Cloud Firestore
- **Notificaciones**: Firebase Cloud Messaging

## 📋 Prerrequisitos

- Flutter SDK 3.13+
- Dart SDK 3.1+
- Node.js (para Firebase CLI)
- Android Studio (para desarrollo Android)
- VS Code con extensiones Flutter/Dart

## ⚙️ Instalación

### 1. Clonar el repositorio

```bash
git clone [URL_DEL_REPOSITORIO]
cd grocery_manager
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar Firebase

1. **Crear proyecto en Firebase Console:**
   - Ve a: https://console.firebase.google.com/
   - Crea un nuevo proyecto: "grocery-manager-app"

2. **Habilitar servicios:**
   - Authentication (Email/Password)
   - Firestore Database
   - Cloud Messaging

3. **Configurar FlutterFire:**
   ```bash
   # Instalar herramientas
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   
   # Configurar proyecto
   firebase login
   flutterfire configure
   ```

## 🔧 Desarrollo

### Ejecutar en modo desarrollo

```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS (solo en Mac)
flutter run -d ios
```

### Comandos útiles

```bash
# Analizar código
flutter analyze

# Formatear código
flutter format .

# Ejecutar tests
flutter test
```

## 📱 Funcionalidades Actuales

- ✅ UI básica con 4 pestañas principales
- ✅ Estructura de proyecto Flutter con Firebase
- ✅ Configuración de dependencias
- 🔄 Autenticación Firebase (pendiente configuración)
- 🔄 Base de datos Firestore (pendiente configuración)
- 🔄 Notificaciones push (pendiente configuración)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Añadir nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.
