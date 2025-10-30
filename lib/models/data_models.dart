// 📊 MODELO DE DATOS FIRESTORE
// ============================

import 'package:cloud_firestore/cloud_firestore.dart';

// 🏗️ ESTRUCTURA DE COLECCIONES Y DOCUMENTOS

/*
firestore/
├── users/{userId}
│   ├── profile: UserProfile
│   ├── settings: UserSettings
│   └── stats: UserStats
├── inventories/{userId}/items/{itemId}
│   └── item: InventoryItem
├── purchases/{userId}/history/{purchaseId}
│   └── purchase: Purchase
├── recipes/{recipeId}
│   └── recipe: Recipe
├── categories/{categoryId}
│   └── category: Category
└── notifications/{userId}/messages/{notificationId}
    └── notification: Notification
*/

// 👤 USER PROFILE
class UserProfile {
  final String uid; // Firebase Auth UID
  final String email; // Email del usuario
  final String displayName; // Nombre para mostrar
  final String? photoURL; // URL de foto de perfil
  final DateTime createdAt; // Fecha de registro
  final DateTime lastLoginAt; // Último acceso
  final bool isEmailVerified; // Email verificado

  // Configuración del hogar
  final String? householdName; // Nombre del hogar
  final List<String> members; // IDs de miembros del hogar
  final String role; // 'owner', 'member'

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.createdAt,
    required this.lastLoginAt,
    required this.isEmailVerified,
    this.householdName,
    required this.members,
    required this.role,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp).toDate(),
      isEmailVerified: data['isEmailVerified'] ?? false,
      householdName: data['householdName'],
      members: List<String>.from(data['members'] ?? []),
      role: data['role'] ?? 'owner',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      'isEmailVerified': isEmailVerified,
      'householdName': householdName,
      'members': members,
      'role': role,
    };
  }
}

// ⚙️ USER SETTINGS
class UserSettings {
  // Notificaciones
  final bool enablePushNotifications;
  final bool enableEmailNotifications;
  final bool enableExpirationAlerts;
  final int expirationAlertDays; // Días antes del vencimiento para alertar

  // Preferencias
  final String language; // 'es', 'en'
  final String theme; // 'light', 'dark', 'system'
  final String dateFormat; // 'DD/MM/YYYY', 'MM/DD/YYYY'
  final String currency; // 'USD', 'EUR', 'MXN'

  // Inventario
  final String defaultUnit; // 'kg', 'lbs', 'units'
  final bool autoAddToShoppingList; // Auto-agregar a lista de compras
  final List<String> favoriteCategories;

  UserSettings({
    this.enablePushNotifications = true,
    this.enableEmailNotifications = true,
    this.enableExpirationAlerts = true,
    this.expirationAlertDays = 3,
    this.language = 'es',
    this.theme = 'system',
    this.dateFormat = 'DD/MM/YYYY',
    this.currency = 'USD',
    this.defaultUnit = 'units',
    this.autoAddToShoppingList = true,
    this.favoriteCategories = const [],
  });

  factory UserSettings.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserSettings(
      enablePushNotifications: data['enablePushNotifications'] ?? true,
      enableEmailNotifications: data['enableEmailNotifications'] ?? true,
      enableExpirationAlerts: data['enableExpirationAlerts'] ?? true,
      expirationAlertDays: data['expirationAlertDays'] ?? 3,
      language: data['language'] ?? 'es',
      theme: data['theme'] ?? 'system',
      dateFormat: data['dateFormat'] ?? 'DD/MM/YYYY',
      currency: data['currency'] ?? 'USD',
      defaultUnit: data['defaultUnit'] ?? 'units',
      autoAddToShoppingList: data['autoAddToShoppingList'] ?? true,
      favoriteCategories: List<String>.from(data['favoriteCategories'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'enablePushNotifications': enablePushNotifications,
      'enableEmailNotifications': enableEmailNotifications,
      'enableExpirationAlerts': enableExpirationAlerts,
      'expirationAlertDays': expirationAlertDays,
      'language': language,
      'theme': theme,
      'dateFormat': dateFormat,
      'currency': currency,
      'defaultUnit': defaultUnit,
      'autoAddToShoppingList': autoAddToShoppingList,
      'favoriteCategories': favoriteCategories,
    };
  }
}

// 🛒 INVENTORY ITEM
class InventoryItem {
  final String id; // ID único del item
  final String userId; // Propietario del item
  final String name; // Nombre del producto
  final String? brand; // Marca del producto
  final String category; // Categoría del producto

  // Cantidades
  final double quantity; // Cantidad actual
  final double originalQuantity; // Cantidad inicial
  final String unit; // 'kg', 'g', 'l', 'ml', 'units'

  // Fechas
  final DateTime purchaseDate; // Fecha de compra
  final DateTime expirationDate; // Fecha de vencimiento
  final DateTime addedAt; // Fecha de adición al inventario
  final DateTime? lastUpdated; // Última modificación

  // Ubicación y organización
  final String? location; // 'refrigerator', 'pantry', 'freezer'
  final String? shelf; // Ubicación específica
  final List<String> tags; // Tags personalizados

  // Valor económico
  final double? purchasePrice; // Precio de compra
  final double? unitPrice; // Precio por unidad
  final String? store; // Tienda donde se compró

  // Estado
  final String status; // 'fresh', 'expiring_soon', 'expired', 'consumed'
  final double consumedQuantity; // Cantidad ya consumida

  // Metadata
  final String? barcode; // Código de barras
  final String? imageUrl; // URL de imagen del producto
  final Map<String, dynamic>? nutritionInfo; // Información nutricional

  InventoryItem({
    required this.id,
    required this.userId,
    required this.name,
    this.brand,
    required this.category,
    required this.quantity,
    required this.originalQuantity,
    required this.unit,
    required this.purchaseDate,
    required this.expirationDate,
    required this.addedAt,
    this.lastUpdated,
    this.location,
    this.shelf,
    this.tags = const [],
    this.purchasePrice,
    this.unitPrice,
    this.store,
    this.status = 'fresh',
    this.consumedQuantity = 0.0,
    this.barcode,
    this.imageUrl,
    this.nutritionInfo,
  });

  factory InventoryItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return InventoryItem(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      brand: data['brand'],
      category: data['category'] ?? '',
      quantity: (data['quantity'] ?? 0).toDouble(),
      originalQuantity: (data['originalQuantity'] ?? 0).toDouble(),
      unit: data['unit'] ?? 'units',
      purchaseDate: (data['purchaseDate'] as Timestamp).toDate(),
      expirationDate: (data['expirationDate'] as Timestamp).toDate(),
      addedAt: (data['addedAt'] as Timestamp).toDate(),
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
      location: data['location'],
      shelf: data['shelf'],
      tags: List<String>.from(data['tags'] ?? []),
      purchasePrice: data['purchasePrice']?.toDouble(),
      unitPrice: data['unitPrice']?.toDouble(),
      store: data['store'],
      status: data['status'] ?? 'fresh',
      consumedQuantity: (data['consumedQuantity'] ?? 0).toDouble(),
      barcode: data['barcode'],
      imageUrl: data['imageUrl'],
      nutritionInfo: data['nutritionInfo'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'brand': brand,
      'category': category,
      'quantity': quantity,
      'originalQuantity': originalQuantity,
      'unit': unit,
      'purchaseDate': Timestamp.fromDate(purchaseDate),
      'expirationDate': Timestamp.fromDate(expirationDate),
      'addedAt': Timestamp.fromDate(addedAt),
      'lastUpdated':
          lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
      'location': location,
      'shelf': shelf,
      'tags': tags,
      'purchasePrice': purchasePrice,
      'unitPrice': unitPrice,
      'store': store,
      'status': status,
      'consumedQuantity': consumedQuantity,
      'barcode': barcode,
      'imageUrl': imageUrl,
      'nutritionInfo': nutritionInfo,
    };
  }

  // Helper methods
  bool get isExpiringSoon {
    final now = DateTime.now();
    final daysUntilExpiration = expirationDate.difference(now).inDays;
    return daysUntilExpiration <= 3 && daysUntilExpiration >= 0;
  }

  bool get isExpired {
    return DateTime.now().isAfter(expirationDate);
  }

  double get remainingPercentage {
    if (originalQuantity == 0) return 0;
    return (quantity / originalQuantity) * 100;
  }
}

// 📂 CATEGORY
class Category {
  final String id; // ID único
  final String name; // Nombre de la categoría
  final String? description; // Descripción
  final String? iconName; // Nombre del icono
  final String color; // Color hexadecimal
  final bool isDefault; // Categoría por defecto del sistema
  final String? parentCategory; // Categoría padre (para subcategorías)
  final int sortOrder; // Orden de visualización

  // Configuración de inventario
  final int defaultExpirationDays; // Días por defecto hasta vencimiento
  final String defaultUnit; // Unidad por defecto
  final String? defaultLocation; // Ubicación por defecto

  Category({
    required this.id,
    required this.name,
    this.description,
    this.iconName,
    this.color = '#2196F3',
    this.isDefault = false,
    this.parentCategory,
    this.sortOrder = 0,
    this.defaultExpirationDays = 7,
    this.defaultUnit = 'units',
    this.defaultLocation,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'],
      iconName: data['iconName'],
      color: data['color'] ?? '#2196F3',
      isDefault: data['isDefault'] ?? false,
      parentCategory: data['parentCategory'],
      sortOrder: data['sortOrder'] ?? 0,
      defaultExpirationDays: data['defaultExpirationDays'] ?? 7,
      defaultUnit: data['defaultUnit'] ?? 'units',
      defaultLocation: data['defaultLocation'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'iconName': iconName,
      'color': color,
      'isDefault': isDefault,
      'parentCategory': parentCategory,
      'sortOrder': sortOrder,
      'defaultExpirationDays': defaultExpirationDays,
      'defaultUnit': defaultUnit,
      'defaultLocation': defaultLocation,
    };
  }
}

// Categorías por defecto del sistema
class DefaultCategories {
  static List<Category> get all => [
        Category(
          id: 'fruits',
          name: 'Frutas',
          iconName: 'apple',
          color: '#4CAF50',
          isDefault: true,
          defaultExpirationDays: 7,
          defaultUnit: 'kg',
          defaultLocation: 'refrigerator',
        ),
        Category(
          id: 'vegetables',
          name: 'Verduras',
          iconName: 'carrot',
          color: '#8BC34A',
          isDefault: true,
          defaultExpirationDays: 5,
          defaultUnit: 'kg',
          defaultLocation: 'refrigerator',
        ),
        Category(
          id: 'dairy',
          name: 'Lácteos',
          iconName: 'milk',
          color: '#FFF',
          isDefault: true,
          defaultExpirationDays: 7,
          defaultUnit: 'l',
          defaultLocation: 'refrigerator',
        ),
        Category(
          id: 'meat',
          name: 'Carnes',
          iconName: 'meat',
          color: '#F44336',
          isDefault: true,
          defaultExpirationDays: 3,
          defaultUnit: 'kg',
          defaultLocation: 'refrigerator',
        ),
        Category(
          id: 'grains',
          name: 'Granos y Cereales',
          iconName: 'grain',
          color: '#FF9800',
          isDefault: true,
          defaultExpirationDays: 365,
          defaultUnit: 'kg',
          defaultLocation: 'pantry',
        ),
        Category(
          id: 'beverages',
          name: 'Bebidas',
          iconName: 'drink',
          color: '#2196F3',
          isDefault: true,
          defaultExpirationDays: 30,
          defaultUnit: 'l',
          defaultLocation: 'pantry',
        ),
        Category(
          id: 'condiments',
          name: 'Condimentos',
          iconName: 'spice',
          color: '#795548',
          isDefault: true,
          defaultExpirationDays: 180,
          defaultUnit: 'units',
          defaultLocation: 'pantry',
        ),
        Category(
          id: 'frozen',
          name: 'Congelados',
          iconName: 'snowflake',
          color: '#00BCD4',
          isDefault: true,
          defaultExpirationDays: 90,
          defaultUnit: 'kg',
          defaultLocation: 'freezer',
        ),
      ];
}
