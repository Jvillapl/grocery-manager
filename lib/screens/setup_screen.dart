import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../services/category_service.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  bool _isLoading = false;
  String _status = 'Verificando configuración...';
  List<String> _completedSteps = [];
  List<String> _pendingSteps = [];

  @override
  void initState() {
    super.initState();
    _checkFirebaseConfiguration();
  }

  Future<void> _checkFirebaseConfiguration() async {
    setState(() {
      _isLoading = true;
      _status = 'Verificando Firebase...';
    });

    try {
      // Verificar autenticación anónima
      await _checkAuthentication();
      
      // Verificar categorías por defecto
      await _checkDefaultCategories();
      
      // Verificar conexión a Firestore
      await _checkFirestoreConnection();
      
    } catch (e) {
      setState(() {
        _status = 'Error en configuración: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkAuthentication() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Intentar login anónimo
        await FirebaseService().signInAnonymously();
        setState(() {
          _completedSteps.add('✅ Autenticación anónima configurada');
        });
      } else {
        setState(() {
          _completedSteps.add('✅ Usuario ya autenticado');
        });
      }
    } catch (e) {
      setState(() {
        _pendingSteps.add('❌ Error en autenticación: $e');
      });
    }
  }

  Future<void> _checkDefaultCategories() async {
    try {
      // Inicializar categorías por defecto
      await CategoryService().initializeDefaultCategories();
      setState(() {
        _completedSteps.add('✅ Categorías por defecto inicializadas');
      });
    } catch (e) {
      setState(() {
        _pendingSteps.add('❌ Error al inicializar categorías: $e');
      });
    }
  }

  Future<void> _checkFirestoreConnection() async {
    try {
      // Intentar obtener categorías para verificar conexión
      final categories = await CategoryService().getDefaultCategories();
      if (categories.isNotEmpty) {
        setState(() {
          _completedSteps.add('✅ Conexión a Firestore funcionando');
          _status = 'Configuración completada exitosamente!';
        });
      } else {
        setState(() {
          _pendingSteps.add('⚠️ Firestore conectado pero sin datos');
        });
      }
    } catch (e) {
      setState(() {
        _pendingSteps.add('❌ Error de conexión a Firestore: $e');
      });
    }
  }

  Future<void> _retryConfiguration() async {
    setState(() {
      _completedSteps.clear();
      _pendingSteps.clear();
    });
    await _checkFirebaseConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración Firebase'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado actual
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (_isLoading)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          Icon(
                            _pendingSteps.isEmpty ? Icons.check_circle : Icons.warning,
                            color: _pendingSteps.isEmpty ? Colors.green : Colors.orange,
                          ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _status,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Pasos completados
            if (_completedSteps.isNotEmpty) ...[
              Text(
                'Configuración Completada:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _completedSteps.map((step) => 
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(step),
                      )
                    ).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Pasos pendientes
            if (_pendingSteps.isNotEmpty) ...[
              Text(
                'Requiere Atención:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _pendingSteps.map((step) => 
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(step),
                      )
                    ).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Instrucciones
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Instrucciones',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Si ves errores arriba, revisa FIREBASE_MANUAL_SETUP.md\n'
                      '2. Configura Firebase Console según las instrucciones\n'
                      '3. Actualiza firebase_options.dart con las claves reales\n'
                      '4. Presiona "Reintentar" una vez completado',
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _retryConfiguration,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pendingSteps.isEmpty ? () {
                      // Navegar a la app principal
                      Navigator.of(context).pushReplacementNamed('/home');
                    } : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Continuar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}