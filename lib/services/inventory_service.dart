import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/data_models.dart';

class InventoryService {
  // Singleton instance
  static final InventoryService _instance = InventoryService._internal();
  factory InventoryService() => _instance;
  InventoryService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // 📊 MÉTODOS DE LECTURA

  /// Obtiene el stream del inventario del usuario actual
  Stream<List<InventoryItem>> getInventoryStream() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('inventories')
        .doc(_currentUserId!)
        .collection('items')
        .orderBy('expirationDate', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => InventoryItem.fromFirestore(doc))
          .toList();
    });
  }

  /// Obtiene items que están próximos a vencer
  Stream<List<InventoryItem>> getExpiringSoonItems({int days = 3}) {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    final DateTime limitDate = DateTime.now().add(Duration(days: days));

    return _firestore
        .collection('inventories')
        .doc(_currentUserId!)
        .collection('items')
        .where('expirationDate',
            isLessThanOrEqualTo: Timestamp.fromDate(limitDate))
        .where('status', isNotEqualTo: 'consumed')
        .orderBy('expirationDate')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => InventoryItem.fromFirestore(doc))
          .toList();
    });
  }

  /// Obtiene items por categoría
  Stream<List<InventoryItem>> getItemsByCategory(String category) {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('inventories')
        .doc(_currentUserId!)
        .collection('items')
        .where('category', isEqualTo: category)
        .where('status', isNotEqualTo: 'consumed')
        .orderBy('expirationDate')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => InventoryItem.fromFirestore(doc))
          .toList();
    });
  }

  /// Busca items por nombre
  Future<List<InventoryItem>> searchItems(String query) async {
    if (_currentUserId == null) return [];

    // Firestore no soporta búsqueda de texto completo nativa
    // Esta es una implementación básica que mejorará con Algolia o similar
    final snapshot = await _firestore
        .collection('inventories')
        .doc(_currentUserId!)
        .collection('items')
        .where('status', isNotEqualTo: 'consumed')
        .get();

    final items =
        snapshot.docs.map((doc) => InventoryItem.fromFirestore(doc)).toList();

    // Filtrar por nombre en el cliente (temporal)
    return items
        .where((item) =>
            item.name.toLowerCase().contains(query.toLowerCase()) ||
            (item.brand?.toLowerCase().contains(query.toLowerCase()) ?? false))
        .toList();
  }

  // ✏️ MÉTODOS DE ESCRITURA

  /// Agrega un nuevo item al inventario
  Future<String> addItem(InventoryItem item) async {
    if (_currentUserId == null) {
      throw Exception('Usuario no autenticado');
    }

    try {
      final docRef = await _firestore
          .collection('inventories')
          .doc(_currentUserId!)
          .collection('items')
          .add(item.toFirestore());

      // Actualizar estadísticas del usuario
      await _updateUserStats();

      return docRef.id;
    } catch (e) {
      throw Exception('Error al agregar item: $e');
    }
  }

  /// Actualiza un item existente
  Future<void> updateItem(String itemId, Map<String, dynamic> updates) async {
    if (_currentUserId == null) {
      throw Exception('Usuario no autenticado');
    }

    try {
      updates['lastUpdated'] = Timestamp.now();

      await _firestore
          .collection('inventories')
          .doc(_currentUserId!)
          .collection('items')
          .doc(itemId)
          .update(updates);

      await _updateUserStats();
    } catch (e) {
      throw Exception('Error al actualizar item: $e');
    }
  }

  /// Consume una cantidad del producto
  Future<void> consumeItem(String itemId, double consumedQuantity) async {
    if (_currentUserId == null) {
      throw Exception('Usuario no autenticado');
    }

    try {
      final docRef = _firestore
          .collection('inventories')
          .doc(_currentUserId!)
          .collection('items')
          .doc(itemId);

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        if (!doc.exists) {
          throw Exception('Item no encontrado');
        }

        final item = InventoryItem.fromFirestore(doc);
        final newQuantity = item.quantity - consumedQuantity;
        final newConsumedQuantity = item.consumedQuantity + consumedQuantity;

        String newStatus = item.status;
        if (newQuantity <= 0) {
          newStatus = 'consumed';
        }

        transaction.update(docRef, {
          'quantity': newQuantity,
          'consumedQuantity': newConsumedQuantity,
          'status': newStatus,
          'lastUpdated': Timestamp.now(),
        });
      });

      await _updateUserStats();
    } catch (e) {
      throw Exception('Error al consumir item: $e');
    }
  }

  /// Marca un item como vencido
  Future<void> markAsExpired(String itemId) async {
    await updateItem(itemId, {'status': 'expired'});
  }

  /// Elimina un item del inventario
  Future<void> deleteItem(String itemId) async {
    if (_currentUserId == null) {
      throw Exception('Usuario no autenticado');
    }

    try {
      await _firestore
          .collection('inventories')
          .doc(_currentUserId!)
          .collection('items')
          .doc(itemId)
          .delete();

      await _updateUserStats();
    } catch (e) {
      throw Exception('Error al eliminar item: $e');
    }
  }

  // 📊 ESTADÍSTICAS Y ANÁLISIS

  /// Obtiene estadísticas del inventario
  Future<Map<String, dynamic>> getInventoryStats() async {
    if (_currentUserId == null) return {};

    try {
      final snapshot = await _firestore
          .collection('inventories')
          .doc(_currentUserId!)
          .collection('items')
          .get();

      final items =
          snapshot.docs.map((doc) => InventoryItem.fromFirestore(doc)).toList();

      final activeItems =
          items.where((item) => item.status != 'consumed').toList();
      final expiredItems = items
          .where((item) => item.isExpired && item.status != 'consumed')
          .toList();
      final expiringSoonItems = items
          .where((item) => item.isExpiringSoon && !item.isExpired)
          .toList();

      final Map<String, int> itemsByCategory = {};
      final Map<String, double> valueByCategory = {};
      double totalValue = 0;

      for (final item in activeItems) {
        // Contar por categoría
        itemsByCategory[item.category] =
            (itemsByCategory[item.category] ?? 0) + 1;

        // Valor por categoría
        final itemValue =
            (item.purchasePrice ?? 0) * (item.quantity / item.originalQuantity);
        valueByCategory[item.category] =
            (valueByCategory[item.category] ?? 0) + itemValue;
        totalValue += itemValue;
      }

      return {
        'totalItems': activeItems.length,
        'expiredItems': expiredItems.length,
        'expiringSoonItems': expiringSoonItems.length,
        'totalValue': totalValue,
        'itemsByCategory': itemsByCategory,
        'valueByCategory': valueByCategory,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('Error al obtener estadísticas: $e');
      return {};
    }
  }

  /// Actualiza las estadísticas del usuario
  Future<void> _updateUserStats() async {
    if (_currentUserId == null) return;

    try {
      final stats = await getInventoryStats();

      await _firestore
          .collection('users')
          .doc(_currentUserId!)
          .collection('stats')
          .doc('inventory')
          .set(stats, SetOptions(merge: true));
    } catch (e) {
      print('Error al actualizar estadísticas de usuario: $e');
    }
  }

  // 🔄 MÉTODOS DE UTILIDAD

  /// Verifica y actualiza el estado de items vencidos
  Future<void> checkAndUpdateExpiredItems() async {
    if (_currentUserId == null) return;

    try {
      final now = DateTime.now();
      final snapshot = await _firestore
          .collection('inventories')
          .doc(_currentUserId!)
          .collection('items')
          .where('expirationDate', isLessThan: Timestamp.fromDate(now))
          .where('status', isNotEqualTo: 'expired')
          .get();

      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {
          'status': 'expired',
          'lastUpdated': Timestamp.now(),
        });
      }

      if (snapshot.docs.isNotEmpty) {
        await batch.commit();
        await _updateUserStats();
      }
    } catch (e) {
      print('Error al actualizar items vencidos: $e');
    }
  }

  /// Genera un reporte de inventario
  Future<Map<String, dynamic>> generateInventoryReport() async {
    if (_currentUserId == null) return {};

    try {
      final stats = await getInventoryStats();
      final now = DateTime.now();

      return {
        'reportDate': now.toIso8601String(),
        'userId': _currentUserId,
        'summary': stats,
        'recommendations': _generateRecommendations(stats),
      };
    } catch (e) {
      print('Error al generar reporte: $e');
      return {};
    }
  }

  List<String> _generateRecommendations(Map<String, dynamic> stats) {
    final recommendations = <String>[];

    final expiredCount = stats['expiredItems'] as int? ?? 0;
    final expiringSoonCount = stats['expiringSoonItems'] as int? ?? 0;
    final totalItems = stats['totalItems'] as int? ?? 0;

    if (expiredCount > 0) {
      recommendations.add(
          'Tienes $expiredCount productos vencidos. Considera eliminarlos del inventario.');
    }

    if (expiringSoonCount > 0) {
      recommendations.add(
          '$expiringSoonCount productos vencen pronto. Úsalos primero en tus comidas.');
    }

    if (totalItems > 50) {
      recommendations.add(
          'Tu inventario está muy lleno. Considera consumir más productos antes de comprar nuevos.');
    }

    if (totalItems < 5) {
      recommendations.add(
          'Tu inventario está bajo. Es un buen momento para hacer compras.');
    }

    return recommendations;
  }
}
