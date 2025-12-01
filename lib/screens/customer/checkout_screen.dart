import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/order_model.dart';
import '../../theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'qris';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Text(
              'Ringkasan Pesanan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Consumer<CartProvider>(
              builder: (context, cartProvider, _) {
                return Column(
                  children: [
                    ...cartProvider.items.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${item.quantity}x @ Rp${item.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Rp${item.totalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          'Rp${cartProvider.totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Biaya Layanan',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          'Rp2.000',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Pajak',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          'Rp${(cartProvider.totalPrice * 0.1).toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rp${(cartProvider.totalPrice + 2000 + (cartProvider.totalPrice * 0.1)).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
            // Payment Method
            Text(
              'Metode Pembayaran',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildPaymentOption(
              'qris',
              'QRIS',
              'Scan kode QR di tempat',
              Icons.qr_code_2,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'ewallet',
              'E-Wallet',
              'OVO, GoPay, DANA',
              Icons.smartphone,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'transfer',
              'Transfer Bank',
              'Transfer langsung',
              Icons.account_balance,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'cash',
              'Tunai',
              'Bayar di tempat',
              Icons.money,
            ),
            const SizedBox(height: 32),
            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Consumer<OrderProvider>(
                builder: (context, orderProvider, _) {
                  return ElevatedButton(
                    onPressed: orderProvider.isLoading
                        ? null
                        : () {
                            final cartProvider =
                                context.read<CartProvider>();
                            final authProvider =
                                context.read<AuthProvider>();

                            if (cartProvider.items.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Keranjang kosong'),
                                ),
                              );
                              return;
                            }

                            final order = Order(
                              id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
                              customerId:
                                  authProvider.currentUser?.id ?? 'unknown',
                              items: cartProvider.items
                                  .map((item) => OrderItem(
                                        productId: item.productId,
                                        productName: item.productName,
                                        price: item.price,
                                        size: item.size,
                                        quantity: item.quantity,
                                        notes: item.notes,
                                      ))
                                  .toList(),
                              totalPrice: cartProvider.totalPrice +
                                  2000 +
                                  (cartProvider.totalPrice * 0.1),
                              paymentMethod: _selectedPaymentMethod,
                              createdAt: DateTime.now(),
                            );

                            orderProvider.createOrder(order).then((_) {
                              cartProvider.clearCart();
                              context.go('/customer/order-status');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Pesanan berhasil dibuat'),
                                ),
                              );
                            });
                          },
                    child: orderProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Konfirmasi Pesanan'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedPaymentMethod == value
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color: _selectedPaymentMethod == value
                ? AppTheme.primaryColor
                : const Color(0xFFDDD),
            width: _selectedPaymentMethod == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _selectedPaymentMethod == value
                  ? AppTheme.primaryColor
                  : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Radio(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (val) {
                setState(() {
                  _selectedPaymentMethod = val ?? 'qris';
                });
              },
              activeColor: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
