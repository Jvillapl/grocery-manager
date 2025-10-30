// INSTRUCCIONES PARA CONFIGURAR FIREBASE KEYS
// ===============================================

// 1. Ve a Firebase Console: https://console.firebase.google.com/project/grocery-manager-jvp-2024
// 2. En la configuración del proyecto (⚙️), ve a "General"
// 3. En la sección "Your apps", verás las apps registradas
// 4. Para cada plataforma, obtén la configuración:

// WEB:
// - Clic en el icono </> (Web)
// - Copia los valores de config y reemplaza en firebase_options.dart

// ANDROID:
// - Clic en el icono de Android
// - Descarga google-services.json y colócalo en android/app/

// 5. Habilita servicios en Firebase Console:
//    - Authentication > Sign-in method > Anonymous (Enable)
//    - Firestore Database > Create database > Start in test mode
//    - Storage > Get started
//    - Cloud Messaging

// 6. Para obtener las claves automáticamente, ejecuta:
//    flutterfire configure --project=grocery-manager-jvp-2024

// CONFIGURACIÓN TEMPORAL PARA DESARROLLO:
// Mientras configuras las claves reales, la app puede funcionar con:
// - Firebase simulado localmente
// - Datos mockeados
// - Funcionalidad limitada

class FirebaseConfig {
  static const String projectId = 'grocery-manager-jvp-2024';
  static const String webApiKey = 'YOUR_WEB_API_KEY_HERE';
  static const String androidApiKey = 'YOUR_ANDROID_API_KEY_HERE';
  static const String messagingSenderId = 'YOUR_MESSAGING_SENDER_ID_HERE';
  
  // URLs generadas automáticamente basadas en project ID
  static const String authDomain = '$projectId.firebaseapp.com';
  static const String storageBucket = '$projectId.appspot.com';
  
  // Para desarrollo local
  static const bool useEmulator = true;
  static const String emulatorHost = 'localhost';
  static const int firestorePort = 8080;
  static const int authPort = 9099;
}