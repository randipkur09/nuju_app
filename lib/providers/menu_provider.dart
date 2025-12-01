import 'package:flutter/material.dart';
import '../models/product_model.dart';

class MenuProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Espresso',
      category: 'coffee',
      description: 'Kopi murni tanpa campuran',
      price: 15000,
      image: 'https://via.placeholder.com/200?text=Espresso',
      rating: 4.5,
      reviewCount: 120,
      sizes: ['S', 'M', 'L'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '2',
      name: 'Cappuccino',
      category: 'coffee',
      description: 'Kopi dengan susu dan foam',
      price: 20000,
      image: 'https://via.placeholder.com/200?text=Cappuccino',
      rating: 4.7,
      reviewCount: 150,
      sizes: ['S', 'M', 'L'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '3',
      name: 'Latte',
      category: 'coffee',
      description: 'Kopi dengan susu hangat',
      price: 22000,
      image: 'https://via.placeholder.com/200?text=Latte',
      rating: 4.6,
      reviewCount: 200,
      sizes: ['S', 'M', 'L'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '4',
      name: 'Iced Americano',
      category: 'coffee',
      description: 'Espresso dingin dengan air',
      price: 18000,
      image: 'https://via.placeholder.com/200?text=IcedAmericano',
      rating: 4.4,
      reviewCount: 100,
      sizes: ['M', 'L'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '5',
      name: 'Iced Latte',
      category: 'coffee',
      description: 'Latte dingin segar',
      price: 20000,
      image: 'https://via.placeholder.com/200?text=IcedLatte',
      rating: 4.5,
      reviewCount: 180,
      sizes: ['M', 'L'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '6',
      name: 'Butterscotch',
      category: 'coffee',
      description: 'Kopi dengan rasa butterscotch',
      price: 25000,
      image: 'https://via.placeholder.com/200?text=Butterscotch',
      rating: 4.8,
      reviewCount: 250,
      sizes: ['S', 'M', 'L'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '7',
      name: 'Strawberry Yogurt',
      category: 'non-coffee',
      description: 'Minuman yogurt stroberi segar',
      price: 18000,
      image: 'https://via.placeholder.com/200?text=StrawberryYogurt',
      rating: 4.6,
      reviewCount: 90,
      sizes: ['M', 'L'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '8',
      name: 'Mango Lassi',
      category: 'non-coffee',
      description: 'Minuman mangga tradisional',
      price: 17000,
      image: 'https://via.placeholder.com/200?text=MangoLassi',
      rating: 4.5,
      reviewCount: 75,
      sizes: ['M', 'L'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '9',
      name: 'Croissant',
      category: 'snacks',
      description: 'Croissant lembut dan gurih',
      price: 25000,
      image: 'https://via.placeholder.com/200?text=Croissant',
      rating: 4.7,
      reviewCount: 110,
      sizes: ['1'],
      createdAt: DateTime.now(),
    ),
    Product(
      id: '10',
      name: 'Chocolate Cake',
      category: 'snacks',
      description: 'Kue coklat lezat',
      price: 30000,
      image: 'https://via.placeholder.com/200?text=ChocolateCake',
      rating: 4.8,
      reviewCount: 200,
      sizes: ['1'],
      createdAt: DateTime.now(),
    ),
  ];

  List<Product> _filteredProducts = [];
  String _selectedCategory = 'all';
  bool _isLoading = false;

  List<Product> get products => _filteredProducts.isEmpty ? _products : _filteredProducts;
  List<Product> get allProducts => _products;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  List<String> get categories => [
    'all',
    'coffee',
    'non-coffee',
    'snacks',
  ];

  MenuProvider() {
    _filteredProducts = _products;
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    if (category == 'all') {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) => product.category == category)
          .toList();
    }
    notifyListeners();
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) {
      return _selectedCategory == 'all'
          ? _products
          : _products
              .where((p) => p.category == _selectedCategory)
              .toList();
    }
    return _products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()) &&
            (_selectedCategory == 'all' || product.category == _selectedCategory))
        .toList();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
