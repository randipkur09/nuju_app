// screens/customer/customer_home_screen.dart
import 'package:flutter/material.dart';
import '../../models/menu_model.dart';
import '../../models/order_model.dart';
import '../../services/firestore_service.dart';
import '../../utils/theme.dart';
import 'customer_orders_screen.dart';
import 'customer_favorites_screen.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import '../../services/auth_service.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  int _selectedIndex = 0;
  final List<OrderItem> _cartItems = [];
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _buildHomeContent(),
      const CustomerOrdersScreen(),
      CustomerFavoritesScreen(
        onAddToCart: (product, quantity) {
          _addToCartWithQuantity(product, quantity);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nuju Coffee',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightColor,
                    width: 2,
                  ),
                ),
                child: IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(cartItems: _cartItems),
                      ),
                    );
                  },
                  style: IconButton.styleFrom(
                    foregroundColor: AppTheme.textPrimary,
                  ),
                ),
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  top: 6,
                  right: 4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${_cartItems.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppTheme.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true && mounted) {
                await AuthService().signOut();
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: AppTheme.backgroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        _buildCategoryFilter(),
        Expanded(
          child: StreamBuilder<List<MenuModel>>(
            stream: _firestoreService.getAllMenuItems(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.coffee_outlined,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No menu items available',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              List<MenuModel> menuItems = snapshot.data!
                  .where((item) =>
                      _selectedCategory == 'All' ||
                      item.category == _selectedCategory)
                  .toList();

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return _buildMenuCard(menuItems[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['All', 'Coffee', 'Non-Coffee', 'Food', 'Snack'];

    return Container(
      height: 60,
      color: AppTheme.backgroundColor,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuCard(MenuModel menu) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: menu,
              onAddToCart: (product, quantity) {
                _addToCartWithQuantity(product, quantity);
              },
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product-${menu.id}',
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    color: Colors.grey.shade50,
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: menu.imageUrl.isNotEmpty
                            ? Image.network(
                                menu.imageUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade100,
                                    child: Center(
                                      child: Icon(
                                        Icons.coffee_outlined,
                                        size: 50,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Icon(
                                  Icons.coffee_outlined,
                                  size: 50,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                      ),
                      if (!menu.isAvailable)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'SOLD OUT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (menu.isFeatured == true)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Featured',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (menu.hasDiscount)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${menu.discount?.toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    menu.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (menu.hasDiscount)
                        Text(
                          'Rp ${menu.formattedPrice}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      if (menu.hasDiscount) const SizedBox(width: 4),
                      Text(
                        menu.formattedPrice,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (menu.rating != null && menu.rating! > 0)
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber.shade600,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          menu.formattedRating!,
                          style: TextStyle(
                            color: Colors.amber.shade800,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '•',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (menu.preparationTime != null)
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: Colors.blue.shade600,
                                size: 14,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${menu.preparationTime}m',
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: menu.isAvailable ? () => _addToCart(menu) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        menu.isAvailable ? 'Add to Cart' : 'Unavailable',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(MenuModel menu) {
    setState(() {
      _cartItems.add(OrderItem(
        menuId: menu.id,
        menuName: menu.name,
        price: menu.displayPrice,
        quantity: 1,
        imageUrl: menu.imageUrl,
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text('${menu.name} added to cart'),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addToCartWithQuantity(MenuModel menu, int quantity) {
    setState(() {
      _cartItems.add(OrderItem(
        menuId: menu.id,
        menuName: menu.name,
        price: menu.displayPrice,
        quantity: quantity,
        imageUrl: menu.imageUrl,
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text('$quantity× ${menu.name} added to cart'),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}