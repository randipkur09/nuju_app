import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class MenuModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;
  final DateTime createdAt;
  final String createdBy;
  
  // Properti baru
  final List<String>? ingredients;
  final double? rating;
  final int? preparationTime;
  final int? calories;
  final bool isFeatured;
  final double? discount;
  final double? discountedPrice;
  final List<String>? tags;
  final Map<String, double>? sizePrices; // {Small: 40000, Medium: 50000, Large: 60000}

  MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isAvailable,
    required this.createdAt,
    required this.createdBy,
    
    // Properti baru dengan nilai default
    this.ingredients,
    this.rating,
    this.preparationTime,
    this.calories,
    this.isFeatured = false,
    this.discount,
    this.discountedPrice,
    this.tags,
    this.sizePrices,
  });

  factory MenuModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    
    // Helper function untuk parse list
    List<String> parseStringList(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.whereType<String>().toList();
      }
      return [];
    }
    
    // Helper function untuk parse rating
    double? parseRating(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }
    
    // Helper function untuk parse int
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }
    
    return MenuModel(
      id: doc.id,
      name: data['name']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      price: (data['price'] as num? ?? 0).toDouble(),
      imageUrl: data['imageUrl']?.toString() ?? '',
      category: data['category']?.toString() ?? '',
      isAvailable: data['isAvailable'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy']?.toString() ?? '',
      
      // Properti baru
      ingredients: parseStringList(data['ingredients']),
      rating: parseRating(data['rating']),
      preparationTime: parseInt(data['preparationTime']),
      calories: parseInt(data['calories']),
      isFeatured: data['isFeatured'] as bool? ?? false,
      discount: data['discount'] != null ? (data['discount'] as num).toDouble() : null,
      discountedPrice: data['discountedPrice'] != null ? (data['discountedPrice'] as num).toDouble() : null,
      tags: parseStringList(data['tags']),
      sizePrices: data['sizePrices'] != null 
          ? Map<String, double>.from(
              (data['sizePrices'] as Map).map((k, v) => MapEntry(k.toString(), (v as num).toDouble()))
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'isFeatured': isFeatured,
    };
    
    // Tambahkan properti opsional jika tidak null
    if (ingredients != null && ingredients!.isNotEmpty) {
      map['ingredients'] = ingredients;
    }
    
    if (rating != null) {
      map['rating'] = rating;
    }
    
    if (preparationTime != null) {
      map['preparationTime'] = preparationTime;
    }
    
    if (calories != null) {
      map['calories'] = calories;
    }
    
    if (discount != null) {
      map['discount'] = discount;
    }
    
    if (discountedPrice != null) {
      map['discountedPrice'] = discountedPrice;
    }
    
    if (tags != null && tags!.isNotEmpty) {
      map['tags'] = tags;
    }
    
    if (sizePrices != null && sizePrices!.isNotEmpty) {
      map['sizePrices'] = sizePrices;
    }
    
    return map;
  }
  
  // Helper method untuk mendapatkan harga display
  double get displayPrice {
    if (discount != null && discount! > 0 && discountedPrice != null) {
      return discountedPrice!;
    }
    return price;
  }
  
  // Helper method untuk mengecek apakah ada diskon
  bool get hasDiscount => discount != null && discount! > 0;
  
  // Helper method untuk format harga
String get formattedPrice {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  return formatter.format(displayPrice);
}

// Helper method untuk format harga asli jika ada diskon
String? get formattedOriginalPrice {
  if (!hasDiscount) return null;

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  return formatter.format(price);
}

  
  // Helper method untuk mendapatkan persentase diskon
  String? get discountPercentage {
    if (hasDiscount && discount != null) {
      return '${discount!.toInt()}%';
    }
    return null;
  }
  
  // Helper method untuk format waktu persiapan
  String? get formattedPreparationTime {
    if (preparationTime != null) {
      if (preparationTime! < 60) {
        return '${preparationTime} menit';
      } else {
        final hours = preparationTime! ~/ 60;
        final minutes = preparationTime! % 60;
        if (minutes == 0) {
          return '$hours jam';
        }
        return '$hours jam $minutes menit';
      }
    }
    return null;
  }
  
  // Helper method untuk rating bintang
  String? get formattedRating {
    if (rating != null && rating! > 0) {
      return rating!.toStringAsFixed(1);
    }
    return null;
  }
  
  // Method untuk copy dengan perubahan
  MenuModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool? isAvailable,
    DateTime? createdAt,
    String? createdBy,
    List<String>? ingredients,
    double? rating,
    int? preparationTime,
    int? calories,
    bool? isFeatured,
    double? discount,
    double? discountedPrice,
    List<String>? tags,
  }) {
    return MenuModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      ingredients: ingredients ?? this.ingredients,
      rating: rating ?? this.rating,
      preparationTime: preparationTime ?? this.preparationTime,
      calories: calories ?? this.calories,
      isFeatured: isFeatured ?? this.isFeatured,
      discount: discount ?? this.discount,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      tags: tags ?? this.tags,
    );
  }
  
  @override
  String toString() {
    return 'MenuModel(id: $id, name: $name, price: $price, category: $category)';
  }
}