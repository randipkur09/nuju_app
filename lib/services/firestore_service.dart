import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_model.dart';
import '../models/order_model.dart';
import '../utils/constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============ MENU OPERATIONS ============

  // Get all menu items
  Stream<List<MenuModel>> getMenuItems() {
    return _firestore
        .collection(AppConstants.menuCollection)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MenuModel.fromFirestore(doc)).toList());
  }

  // Add menu item (Admin only)
  Future<String?> addMenuItem(MenuModel menuItem) async {
    try {
      await _firestore.collection(AppConstants.menuCollection).add(menuItem.toMap());
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  // Update menu item (Admin only)
  Future<String?> updateMenuItem({
    required String menuId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.menuCollection)
          .doc(menuId)
          .update(data);
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  // Delete menu item (Admin only)
  Future<String?> deleteMenuItem(String menuId) async {
    try {
      await _firestore
          .collection(AppConstants.menuCollection)
          .doc(menuId)
          .delete();
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  // Get all menu items including unavailable ones for admin
  Stream<List<MenuModel>> getAllMenuItems() {
    return _firestore
        .collection(AppConstants.menuCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MenuModel.fromFirestore(doc)).toList());
  }

  // Update menu availability status
  Future<String?> updateMenuAvailability({
    required String menuId,
    required bool isAvailable,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.menuCollection)
          .doc(menuId)
          .update({'isAvailable': isAvailable});
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  // ============ ORDER OPERATIONS ============

  // Create order
  Future<String?> createOrder(OrderModel order) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.ordersCollection)
          .add(order.toMap());
      
      return null; // Return null on success (no error)
    } catch (e) {
      return e.toString(); // Return error message on failure
    }
  }

  // Get orders by user (Customer view)
  Stream<List<OrderModel>> getOrdersByUser(String userId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList();
          // Sort in memory instead of Firestore
          orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
          return orders;
        });
  }

  // Get all orders (Barista/Admin view)
  Stream<List<OrderModel>> getAllOrders() {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList();
          // Sort in memory instead of Firestore
          orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
          return orders;
        });
  }

  // Update order status (Barista/Admin)
  Future<String?> updateOrderStatus({
    required String orderId,
    required String status,
    String? baristaId,
  }) async {
    try {
      Map<String, dynamic> updateData = {
        'status': status,
      };

      if (status == AppConstants.statusCompleted) {
        updateData['completedDate'] = FieldValue.serverTimestamp();
      }

      if (baristaId != null) {
        updateData['assignedBarista'] = baristaId;
      }

      await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update(updateData);
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  // Get orders by status for barista screen
  Stream<List<OrderModel>> getOrdersByStatus(String status) {
    print('[v0] Getting orders with status: $status');
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) {
          print('[v0] Found ${snapshot.docs.length} orders with status: $status');
          final orders = snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList();
          // Sort in memory by orderDate ascending
          orders.sort((a, b) => a.orderDate.compareTo(b.orderDate));
          return orders;
        });
  }

  // Get customer orders for order history
  Stream<QuerySnapshot> getCustomerOrders(String userId) {
    print('[v0] Getting orders for user: $userId');
    return _firestore
        .collection(AppConstants.ordersCollection)
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  // ============ USER OPERATIONS ============

  // Get all baristas for admin screen
  Stream<List<Map<String, dynamic>>> getBaristas() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .where('role', isEqualTo: AppConstants.roleBarista)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'name': doc.data()['name'] ?? '',
                  'email': doc.data()['email'] ?? '',
                  'phoneNumber': doc.data()['phoneNumber'] ?? '',
                  'createdAt': doc.data()['createdAt'],
                })
            .toList());
  }
}
