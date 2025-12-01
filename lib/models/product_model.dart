class Product {
  final String id;
  final String name;
  final String category; // 'coffee', 'non-coffee', 'snacks'
  final String description;
  final double price;
  final String? image;
  final double rating;
  final int reviewCount;
  final List<String> sizes; // ['S', 'M', 'L']
  final bool isAvailable;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    this.image,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.sizes = const ['M'],
    this.isAvailable = true,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      sizes: List<String>.from(json['sizes'] as List? ?? ['M']),
      isAvailable: json['isAvailable'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'price': price,
      'image': image,
      'rating': rating,
      'reviewCount': reviewCount,
      'sizes': sizes,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
