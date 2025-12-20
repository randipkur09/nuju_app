import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderItem {
  final String menuId;
  final String menuName;
  int quantity;
  final double price;
  final String imageUrl;

  OrderItem({
    required this.menuId,
    required this.menuName,
    required this.quantity,
    required this.price,
    this.imageUrl = '',
  });

  // ✅ formatter rupiah
  static final NumberFormat _idr = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  // ✅ harga dengan titik: Rp12.000
  String get formattedPrice => _idr.format(price);

  // ✅ subtotal item: price * quantity
  String get formattedSubtotal => _idr.format(price * quantity);

  Map<String, dynamic> toMap() {
    return {
      'menuId': menuId,
      'menuName': menuName,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      menuId: map['menuId'] ?? '',
      menuName: map['menuName'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalPrice;
  final String status;
  final DateTime orderDate;
  final DateTime? completedDate;
  final String? assignedBarista;
  final DateTime createdAt;
  final String customerName;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.orderDate,
    this.completedDate,
    this.assignedBarista,
    DateTime? createdAt,
    this.customerName = 'Customer',
  }) : createdAt = createdAt ?? orderDate;

  // ✅ formatter rupiah
  static final NumberFormat _idr = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  // ✅ total dengan titik: Rp120.000
  String get formattedTotalPrice => _idr.format(totalPrice);

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      items: (data['items'] as List)
          .map((item) => OrderItem.fromMap(item))
          .toList(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      completedDate: data['completedDate'] != null
          ? (data['completedDate'] as Timestamp).toDate()
          : null,
      assignedBarista: data['assignedBarista'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : (data['orderDate'] as Timestamp).toDate(),
      customerName: data['customerName'] ?? 'Customer',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'orderDate': Timestamp.fromDate(orderDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'completedDate':
          completedDate != null ? Timestamp.fromDate(completedDate!) : null,
      'assignedBarista': assignedBarista,
      'customerName': customerName,
    };
  }
}
