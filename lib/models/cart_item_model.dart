class CartItem {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final String? image;
  final String size;
  final String notes;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    this.image,
    required this.size,
    this.notes = '',
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String?,
      size: json['size'] as String,
      notes: json['notes'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'price': price,
      'image': image,
      'size': size,
      'notes': notes,
      'quantity': quantity,
    };
  }

  CartItem copyWith({
    String? id,
    String? productId,
    String? productName,
    double? price,
    String? image,
    String? size,
    String? notes,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      image: image ?? this.image,
      size: size ?? this.size,
      notes: notes ?? this.notes,
      quantity: quantity ?? this.quantity,
    );
  }
}
