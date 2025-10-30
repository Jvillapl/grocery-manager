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

### 3. Configurar Firebase ✅ COMPLETADO

**✅ Estado Actual:**
- Proyecto Firebase creado: `grocery-manager-jvp-2024`
- Firebase CLI instalado y autenticado
- FlutterFire CLI configurado
- Estructura de servicios implementada

**🔧 Próximos pasos:**
```bash
# Para obtener claves API reales:
flutterfire configure --project=grocery-manager-jvp-2024

# O seguir las instrucciones en:
# Ver FIREBASE_SETUP.md para configuración detallada
```

**🔐 Servicios a habilitar en Firebase Console:**
- ✅ Authentication (pendiente activar providers)
- ✅ Firestore Database (pendiente crear)
- ✅ Cloud Messaging
- ✅ Cloud Storage

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
