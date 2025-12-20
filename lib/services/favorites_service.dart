// services/favorites_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/menu_model.dart';

class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _userId => _auth.currentUser?.uid;

  // Collection reference
  CollectionReference get _favoritesCollection =>
      _firestore.collection('favorites');

  // Add to favorites
  Future<void> addToFavorites(MenuModel menu) async {
    if (_userId == null) return;

    try {
      await _favoritesCollection.doc('${_userId}_${menu.id}').set({
        'userId': _userId,
        'menuId': menu.id,
        'menuName': menu.name,
        'price': menu.price,
        'displayPrice': menu.displayPrice,
        'imageUrl': menu.imageUrl,
        'category': menu.category,
        'description': menu.description,
        'rating': menu.rating,
        'preparationTime': menu.preparationTime,
        'calories': menu.calories,
        'discount': menu.discount,
        'isAvailable': menu.isAvailable,
        'isFeatured': menu.isFeatured,
        'ingredients': menu.ingredients,
        'tags': menu.tags,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(String menuId) async {
    if (_userId == null) return;

    try {
      await _favoritesCollection.doc('${_userId}_$menuId').delete();
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  // Check if item is favorited
  Future<bool> isFavorited(String menuId) async {
    if (_userId == null) return false;

    try {
      final doc = await _favoritesCollection.doc('${_userId}_$menuId').get();
      return doc.exists;
    } catch (e) {
      print('Error checking favorite: $e');
      return false;
    }
  }

  // Get all favorites as stream
  Stream<List<MenuModel>> getFavorites() {
    if (_userId == null) {
      print('❌ getFavorites: userId is NULL');
      return Stream.value([]);
    }

    print('✅ getFavorites: Getting favorites for userId: $_userId');

    return _favoritesCollection
    .where('userId', isEqualTo: _userId)
    .snapshots()
    .handleError((e) {
      print('🔥 getFavorites stream error: $e');
    })
    .map((snapshot) {
      print('📦 getFavorites: Found ${snapshot.docs.length} favorites');
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return MenuModel(
          id: data['menuId'] ?? '',
          name: data['menuName'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
          category: data['category'] ?? '',
          description: data['description'] ?? '',
          isAvailable: data['isAvailable'] ?? true,
          rating: data['rating']?.toDouble(),
          preparationTime: data['preparationTime'],
          calories: data['calories'],
          discount: data['discount']?.toDouble(),
          isFeatured: data['isFeatured'] ?? false,
          ingredients: data['ingredients'] != null
              ? List<String>.from(data['ingredients'])
              : null,
          tags: data['tags'] != null
              ? List<String>.from(data['tags'])
              : null,

          // ✅ FIX UTAMA DI SINI
          createdAt: (data['createdAt'] is Timestamp)
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),

          createdBy: data['userId'] ?? '',
        );

      }).toList();
    });

  }

  // Toggle favorite
  Future<bool> toggleFavorite(MenuModel menu) async {
    if (_userId == null) return false;

    try {
      final isFav = await isFavorited(menu.id);
      if (isFav) {
        await removeFromFavorites(menu.id);
        return false;
      } else {
        await addToFavorites(menu);
        return true;
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }

  // Get favorites count
  Future<int> getFavoritesCount() async {
    if (_userId == null) return 0;

    try {
      final snapshot = await _favoritesCollection
          .where('userId', isEqualTo: _userId)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting favorites count: $e');
      return 0;
    }
  }
}