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
      color: AppTheme.backgroundColor, // ← Gunakan AppTheme
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
                          // Header dengan styling dari theme
                          Text(
                            'Dashboard Overview',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 24),

                          /// ===== STATS =====
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.1, // Tambahkan aspect ratio
                            children: [
                              _statCard(
                                'Total Revenue',
                                'Rp ${_formatCurrency(totalRevenue)}',
                                Icons.attach_money_rounded,
                                AppTheme.primaryColor,
                                AppTheme.primaryGradient,
                              ),
                              _statCard(
                                'Total Orders',
                                '${orders.length}',
                                Icons.receipt_long_rounded,
                                AppTheme.secondaryColor,
                                AppTheme.secondaryGradient,
                              ),
                              _statCard(
                                'Active Baristas',
                                '${baristas.length}',
                                Icons.people_alt_rounded,
                                const Color(0xFFD2691E),
                                const LinearGradient(
                                  colors: [Color(0xFFD2691E), Color(0xFFA0522D)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              _statCard(
                                'Menu Items',
                                '${menus.length}',
                                Icons.coffee_rounded,
                                const Color(0xFF8FBC8F),
                                const LinearGradient(
                                  colors: [Color(0xFF8FBC8F), Color(0xFF6B8E23)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          /// ===== RECENT ORDERS =====
                          Text(
                            'Recent Orders',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 12),

                          if (orders.isEmpty)
                            _buildEmptyState()
                          else
                            Column(
                              children: orders.take(5).map((order) {
                                return _buildOrderCard(order, context);
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
    Gradient gradient,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ===== ORDER CARD =====
  Widget _buildOrderCard(OrderModel order, BuildContext context) {
    final statusColor = _getStatusColor(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shopping_bag_rounded,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          order.customerName,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${order.items.length} items • ${_formatTime(order.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Rp ${order.totalPrice.toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _formatStatus(order.status),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===== EMPTY STATE =====
  Widget _buildEmptyState() {
    return Card(
      elevation: 0,
      color: AppTheme.lightColor,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              color: AppTheme.textSecondary,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Belum ada pesanan yang dibuat',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== HELPER METHODS =====
  
  /// Format currency untuk angka besar
  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  /// Format status order
  String _formatStatus(String status) {
    switch (status) {
      case AppConstants.statusPending:
        return 'Pending';
      case AppConstants.statusProcessing:
        return 'Processing';
      case AppConstants.statusReady:
        return 'Ready';
      case AppConstants.statusCompleted:
        return 'Completed';
      case AppConstants.statusCancelled:
        return 'Cancelled';
      default:
        return status;
    }
  }

  /// Get status color
  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.statusPending:
        return Colors.orange;
      case AppConstants.statusProcessing:
        return Colors.blue;
      case AppConstants.statusReady:
        return Colors.green;
      case AppConstants.statusCompleted:
        return Colors.green.shade700;
      case AppConstants.statusCancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Format waktu relatif
  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}