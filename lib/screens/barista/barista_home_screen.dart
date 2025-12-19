import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';

class BaristaHomeScreen extends StatefulWidget {
  const BaristaHomeScreen({super.key});

  @override
  State<BaristaHomeScreen> createState() => _BaristaHomeScreenState();
}

class _BaristaHomeScreenState extends State<BaristaHomeScreen> with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barista Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
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
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppTheme.primaryGreen,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Processing'),
            Tab(text: 'Ready'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(AppConstants.statusPending),
          _buildOrdersList(AppConstants.statusProcessing),
          _buildOrdersList(AppConstants.statusReady),
          _buildOrdersList(AppConstants.statusCompleted),
        ],
      ),
    );
  }

  Widget _buildOrdersList(String status) {
    print('[v0] BaristaHomeScreen - Loading orders with status: $status');
    
    return StreamBuilder<List<OrderModel>>(
      stream: _firestoreService.getOrdersByStatus(status),
      builder: (context, snapshot) {
        print('[v0] BaristaHomeScreen - Connection state: ${snapshot.connectionState}');
        print('[v0] BaristaHomeScreen - Has data: ${snapshot.hasData}');
        print('[v0] BaristaHomeScreen - Orders count: ${snapshot.data?.length ?? 0}');
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print('[v0] BaristaHomeScreen - Error: ${snapshot.error}');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${snapshot.error}'),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No $status orders',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        List<OrderModel> orders = snapshot.data!;

        orders.sort((a, b) => a.orderDate.compareTo(b.orderDate));

        print('[v0] BaristaHomeScreen - Displaying ${orders.length} orders');

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return _buildOrderCard(orders[index], status);
          },
        );
      },
    );
  }

  Widget _buildOrderCard(OrderModel order, String currentStatus) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id.substring(0, 8)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.customerName,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatTime(order.createdAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.menuName}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      Text(
                        'Rp ${(item.price * item.quantity).toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: Rp ${order.totalPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                _buildActionButton(order, currentStatus),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(OrderModel order, String currentStatus) {
    String buttonText;
    String nextStatus;

    switch (currentStatus) {
      case AppConstants.statusPending:
        buttonText = 'Start';
        nextStatus = AppConstants.statusProcessing;
        break;
      case AppConstants.statusProcessing:
        buttonText = 'Ready';
        nextStatus = AppConstants.statusReady;
        break;
      case AppConstants.statusReady:
        buttonText = 'Complete';
        nextStatus = AppConstants.statusCompleted;
        break;
      default:
        return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: () => _updateOrderStatus(order.id, nextStatus),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(buttonText),
    );
  }

  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestoreService.updateOrderStatus(
        orderId: orderId,
        status: newStatus,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order status updated'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
