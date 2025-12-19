import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../models/menu_model.dart';
import '../../services/firestore_service.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Container(
      color: const Color(0xFFF8F6F0),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<List<OrderModel>>(
            stream: firestore.getAllOrders(),
            builder: (context, orderSnap) {
              return StreamBuilder<List<MenuModel>>(
                stream: firestore.getAllMenuItems(),
                builder: (context, menuSnap) {
                  return StreamBuilder<List<Map<String, dynamic>>>(
                    stream: firestore.getBaristas(),
                    builder: (context, baristaSnap) {
                      final orders = orderSnap.data ?? [];
                      final menus = menuSnap.data ?? [];
                      final baristas = baristaSnap.data ?? [];

                      final completedOrders = orders
                          .where((o) =>
                              o.status == AppConstants.statusCompleted)
                          .toList();

                      final totalRevenue = completedOrders.fold(
                          0.0, (sum, o) => sum + o.totalPrice);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dashboard Overview',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),

                          /// ===== STATS =====
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            children: [
                              _statCard(
                                'Revenue',
                                'Rp ${totalRevenue.toStringAsFixed(0)}',
                                Icons.attach_money,
                                Colors.green,
                              ),
                              _statCard(
                                'Orders',
                                '${orders.length}',
                                Icons.receipt_long,
                                Colors.blue,
                              ),
                              _statCard(
                                'Baristas',
                                '${baristas.length}',
                                Icons.people,
                                Colors.orange,
                              ),
                              _statCard(
                                'Menus',
                                '${menus.length}',
                                Icons.menu_book,
                                Colors.purple,
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          /// ===== RECENT ORDERS =====
                          const Text(
                            'Recent Orders',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),

                          if (orders.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  'No orders yet',
                                  style:
                                      TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            Column(
                              children: orders.take(5).map((order) {
                                return Card(
                                  margin: const EdgeInsets.only(
                                      bottom: 12),
                                  child: ListTile(
                                    title: Text(
                                      order.customerName,
                                      style: const TextStyle(
                                          fontWeight:
                                              FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                        '${order.items.length} items'),
                                    trailing: Text(
                                      'Rp ${order.totalPrice.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        color:
                                            AppTheme.primaryGreen,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// ===== STAT CARD =====
  Widget _statCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
