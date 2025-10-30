# 🔥 CONFIGURACIÓN MANUAL FIREBASE CONSOLE
# ========================================

## 🎯 PASOS PARA HABILITAR SERVICIOS

### 1. 🔐 Habilitar Authentication
```
1. Ve a: https://console.firebase.google.com/project/grocery-manager-jvp-2024/authentication
2. Clic en "Get started"
3. En la pestaña "Sign-in method":
   - Habilitar "Anonymous" ✅
   - Habilitar "Email/Password" ✅
   - (Opcional) Habilitar "Google" para futuro
```

### 2. 🗄️ Crear Firestore Database
```
1. Ve a: https://console.firebase.google.com/project/grocery-manager-jvp-2024/firestore
2. Clic en "Create database"
3. Seleccionar "Start in test mode" (cambiaremos las reglas después)
4. Elegir location: "us-central1" (recomendado)
5. Clic en "Done"
```

### 3. 📁 Habilitar Cloud Storage
```
1. Ve a: https://console.firebase.google.com/project/grocery-manager-jvp-2024/storage
2. Clic en "Get started"
3. Seleccionar "Start in test mode"
4. Elegir location: "us-central1"
5. Clic en "Done"
```

### 4. 🔔 Configurar Cloud Messaging
```
1. Ve a: https://console.firebase.google.com/project/grocery-manager-jvp-2024/messaging
2. El servicio se habilitará automáticamente al configurar la app web
```

### 5. 🌐 Obtener configuración Web
```
1. Ve a: https://console.firebase.google.com/project/grocery-manager-jvp-2024/settings/general
2. En "Your apps" buscar el ícono </> (Web)
3. Clic en la app "grocery_manager (web)"
4. En "SDK setup and configuration", copiar la configuración:

const firebaseConfig = {
  apiKey: "TU_API_KEY",
  authDomain: "grocery-manager-jvp-2024.firebaseapp.com",
  projectId: "grocery-manager-jvp-2024",
  storageBucket: "grocery-manager-jvp-2024.appspot.com",
  messagingSenderId: "TU_SENDER_ID",
  appId: "TU_APP_ID"
};
```

### 6. 🔄 Actualizar firebase_options.dart
```dart
// Reemplazar en lib/firebase_options.dart:
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'TU_API_KEY_AQUI',
  appId: 'TU_APP_ID_AQUI',
  messagingSenderId: 'TU_SENDER_ID_AQUI',
  projectId: 'grocery-manager-jvp-2024',
  authDomain: 'grocery-manager-jvp-2024.firebaseapp.com',
  storageBucket: 'grocery-manager-jvp-2024.appspot.com',
);
```

### 7. 🔒 Implementar reglas de seguridad
```
1. Ve a: https://console.firebase.google.com/project/grocery-manager-jvp-2024/firestore/rules
2. Reemplazar las reglas por defecto con el contenido de firestore.rules
3. Clic en "Publish"
```

### 8. ✅ Verificar configuración
```bash
# Ejecutar la app para probar
cd D:\Despensa\grocery_manager
flutter run -d chrome

# Verificar en la consola del navegador que aparezca:
# "Firebase initialized successfully"
```

## 🎯 CATEGORÍAS POR DEFECTO
Ejecutar una vez que Firebase esté configurado:
```dart
// En la app, llamar:
await CategoryService().initializeDefaultCategories();
```

## 🔍 VERIFICACIÓN
- ✅ Authentication habilitado
- ✅ Firestore Database creado
- ✅ Cloud Storage habilitado
- ✅ Reglas de seguridad implementadas
- ✅ App conectándose sin errores

## 🚀 SIGUIENTE PASO
Una vez completada esta configuración:
1. Actualizar firebase_options.dart con claves reales
2. Ejecutar flutter run -d chrome
3. Verificar conexión exitosa
4. Proceder con implementación de UI