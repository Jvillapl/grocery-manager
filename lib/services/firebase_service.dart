import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  // Singleton instance
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in anonymously (for demo purposes)
  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Get user's inventory
  Stream<QuerySnapshot> getUserInventory(String userId) {
    return _firestore
        .collection('inventories')
        .doc(userId)
        .collection('items')
        .snapshots();
  }

  // Add item to inventory
  Future<void> addInventoryItem(
      String userId, Map<String, dynamic> item) async {
    try {
      await _firestore
          .collection('inventories')
          .doc(userId)
          .collection('items')
          .add(item);
    } catch (e) {
      print('Error adding inventory item: $e');
      rethrow;
    }
  }

  // Initialize user data
  Future<void> initializeUserData(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error initializing user data: $e');
    }
  }
}
