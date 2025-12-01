class Order {
  final String id;
  final String customerId;
  final String? baristaId;
  final List<OrderItem> items;
  final double totalPrice;
  final String status; // 'pending', 'confirmed', 'processing', 'ready', 'completed'
  final String paymentMethod; // 'qris', 'ewallet', 'transfer', 'cash'
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Order({
    required this.id,
    required this.customerId,
    this.baristaId,
    required this.items,
    required this.totalPrice,
    this.status = 'pending',
    this.paymentMethod = 'cash',
    this.notes,
    required this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      baristaId: json['baristaId'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String? ?? 'pending',
      paymentMethod: json['paymentMethod'] as String? ?? 'cash',
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'baristaId': baristaId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'status': status,
      'paymentMethod': paymentMethod,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final String size;
  final int quantity;
  final String? notes;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.size,
    required this.quantity,
    this.notes,
  });

  double get subtotal => price * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      price: (json['price'] as num).toDouble(),
      size: json['size'] as String,
      quantity: json['quantity'] as int,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'size': size,
      'quantity': quantity,
      'notes': notes,
    };
  }
}
