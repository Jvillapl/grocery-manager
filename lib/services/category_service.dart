import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/data_models.dart';

class CategoryService {
  // Singleton instance
  static final CategoryService _instance = CategoryService._internal();
  factory CategoryService() => _instance;
  CategoryService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 📂 MÉTODOS DE LECTURA

  /// Obtiene todas las categorías disponibles
  Stream<List<Category>> getCategoriesStream() {
    return _firestore
        .collection('categories')
        .orderBy('sortOrder')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    });
  }

  /// Obtiene categorías por defecto del sistema
  Future<List<Category>> getDefaultCategories() async {
    try {
      final snapshot = await _firestore
          .collection('categories')
          .where('isDefault', isEqualTo: true)
          .orderBy('sortOrder')
          .get();

      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error al obtener categorías por defecto: $e');
      return DefaultCategories.all;
    }
  }

  /// Obtiene una categoría específica por ID
  Future<Category?> getCategoryById(String categoryId) async {
    try {
      final doc =
          await _firestore.collection('categories').doc(categoryId).get();

      if (doc.exists) {
        return Category.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error al obtener categoría: $e');
      return null;
    }
  }

  // ✏️ MÉTODOS DE ESCRITURA

  /// Inicializa las categorías por defecto en Firestore
  Future<void> initializeDefaultCategories() async {
    try {
      // Verificar si ya existen categorías
      final snapshot = await _firestore
          .collection('categories')
          .where('isDefault', isEqualTo: true)
          .get();

      if (snapshot.docs.isEmpty) {
        // Agregar categorías por defecto
        final batch = _firestore.batch();

        for (final category in DefaultCategories.all) {
          final docRef = _firestore.collection('categories').doc(category.id);
          batch.set(docRef, category.toFirestore());
        }

        await batch.commit();
        print('Categorías por defecto inicializadas');
      }
    } catch (e) {
      print('Error al inicializar categorías por defecto: $e');
    }
  }

  /// Agrega una nueva categoría personalizada
  Future<String> addCustomCategory(Category category) async {
    try {
      final docRef =
          await _firestore.collection('categories').add(category.toFirestore());

      return docRef.id;
    } catch (e) {
      throw Exception('Error al agregar categoría: $e');
    }
  }

  /// Actualiza una categoría existente
  Future<void> updateCategory(
      String categoryId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('categories').doc(categoryId).update(updates);
    } catch (e) {
      throw Exception('Error al actualizar categoría: $e');
    }
  }

  /// Elimina una categoría (solo si no es por defecto)
  Future<void> deleteCategory(String categoryId) async {
    try {
      final doc =
          await _firestore.collection('categories').doc(categoryId).get();

      if (doc.exists) {
        final category = Category.fromFirestore(doc);
        if (!category.isDefault) {
          await _firestore.collection('categories').doc(categoryId).delete();
        } else {
          throw Exception('No se pueden eliminar categorías por defecto');
        }
      }
    } catch (e) {
      throw Exception('Error al eliminar categoría: $e');
    }
  }

  // 🔧 MÉTODOS DE UTILIDAD

  /// Obtiene configuración por defecto para una categoría
  Map<String, dynamic> getCategoryDefaults(String categoryName) {
    final category = DefaultCategories.all
        .where((cat) => cat.name.toLowerCase() == categoryName.toLowerCase())
        .firstOrNull;

    if (category != null) {
      return {
        'defaultExpirationDays': category.defaultExpirationDays,
        'defaultUnit': category.defaultUnit,
        'defaultLocation': category.defaultLocation,
        'color': category.color,
        'iconName': category.iconName,
      };
    }

    // Valores por defecto si no se encuentra la categoría
    return {
      'defaultExpirationDays': 7,
      'defaultUnit': 'units',
      'defaultLocation': 'pantry',
      'color': '#2196F3',
      'iconName': 'category',
    };
  }

  /// Sugiere categoría basada en el nombre del producto
  String suggestCategory(String productName) {
    final name = productName.toLowerCase();

    // Mapeo simple de palabras clave a categorías
    final Map<String, List<String>> categoryKeywords = {
      'fruits': [
        'manzana',
        'naranja',
        'plátano',
        'uva',
        'fresa',
        'mango',
        'piña',
        'pera',
        'durazno',
        'kiwi'
      ],
      'vegetables': [
        'tomate',
        'cebolla',
        'ajo',
        'papa',
        'zanahoria',
        'lechuga',
        'pepino',
        'apio',
        'brócoli',
        'espinaca'
      ],
      'dairy': ['leche', 'queso', 'yogur', 'crema', 'mantequilla', 'requesón'],
      'meat': [
        'pollo',
        'res',
        'cerdo',
        'pescado',
        'camarón',
        'carne',
        'jamón',
        'salchicha'
      ],
      'grains': [
        'arroz',
        'pasta',
        'pan',
        'cereal',
        'avena',
        'quinoa',
        'trigo',
        'maíz'
      ],
      'beverages': [
        'agua',
        'jugo',
        'refresco',
        'cerveza',
        'vino',
        'café',
        'té'
      ],
      'condiments': [
        'sal',
        'pimienta',
        'aceite',
        'vinagre',
        'salsa',
        'especias',
        'condimento'
      ],
      'frozen': ['helado', 'congelado', 'frozen'],
    };

    for (final entry in categoryKeywords.entries) {
      for (final keyword in entry.value) {
        if (name.contains(keyword)) {
          return entry.key;
        }
      }
    }

    return 'other'; // Categoría por defecto
  }

  /// Obtiene estadísticas de uso de categorías
  Future<Map<String, int>> getCategoryUsageStats(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('inventories')
          .doc(userId)
          .collection('items')
          .get();

      final Map<String, int> usage = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final category = data['category'] as String? ?? 'other';
        usage[category] = (usage[category] ?? 0) + 1;
      }

      return usage;
    } catch (e) {
      print('Error al obtener estadísticas de categorías: $e');
      return {};
    }
  }

  /// Obtiene categorías más usadas por el usuario
  Future<List<String>> getTopCategories(String userId, {int limit = 5}) async {
    final stats = await getCategoryUsageStats(userId);

    final sorted = stats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).map((entry) => entry.key).toList();
  }

  /// Valida que el nombre de categoría no exista
  Future<bool> isCategoryNameAvailable(String name) async {
    try {
      final snapshot = await _firestore
          .collection('categories')
          .where('name', isEqualTo: name)
          .get();

      return snapshot.docs.isEmpty;
    } catch (e) {
      print('Error al verificar disponibilidad de nombre: $e');
      return false;
    }
  }

  /// Busca categorías por nombre
  Future<List<Category>> searchCategories(String query) async {
    try {
      // Firestore no soporta búsqueda de texto completo nativa
      // Esta es una implementación básica
      final snapshot = await _firestore.collection('categories').get();

      final categories =
          snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();

      return categories
          .where((category) =>
              category.name.toLowerCase().contains(query.toLowerCase()) ||
              (category.description
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ??
                  false))
          .toList();
    } catch (e) {
      print('Error al buscar categorías: $e');
      return [];
    }
  }
}
