import 'package:flutter/material.dart';

class CustomerFavoritesScreen extends StatelessWidget {
  const CustomerFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('Favorites feature coming soon!'),
        ],
      ),
    );
  }
}
