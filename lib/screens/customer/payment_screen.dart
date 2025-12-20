import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class PaymentResult {
  final String method; // qris/dana/shopeepay/cashier
  const PaymentResult(this.method);
}

class PaymentScreen extends StatefulWidget {
  final double totalPrice;

  const PaymentScreen({
    super.key,
    required this.totalPrice,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final label = _selected == 'cashier' ? 'Konfirmasi' : 'Saya sudah bayar';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pembayaran',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context, null), // batal
        ),
      ),
      body: Container(
        color: AppTheme.backgroundColor,
        child: Column(
          children: [
            _header(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _tile(
                    id: 'qris',
                    title: 'QRIS',
                    subtitle: 'Scan QR untuk bayar (semua e-wallet)',
                    icon: Icons.qr_code_2_rounded,
                  ),
                  const SizedBox(height: 12),
                  _tile(
                    id: 'dana',
                    title: 'DANA',
                    subtitle: 'Bayar pakai DANA',
                    icon: Icons.account_balance_wallet_rounded,
                  ),
                  const SizedBox(height: 12),
                  _tile(
                    id: 'shopeepay',
                    title: 'ShopeePay',
                    subtitle: 'Bayar pakai ShopeePay',
                    icon: Icons.payment_rounded,
                  ),
                  const SizedBox(height: 12),
                  _tile(
                    id: 'cashier',
                    title: 'Bayar di Kasir',
                    subtitle: 'Bayar langsung saat ambil pesanan',
                    icon: Icons.storefront_rounded,
                  ),
                  const SizedBox(height: 18),
                  if (_selected != null) _detail(_selected!),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _selected == null
                        ? null
                        : () => Navigator.pop(context, PaymentResult(_selected!)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.payments_rounded,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Total: Rp ${widget.totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final selected = _selected == id;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => setState(() => _selected = id),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppTheme.primaryColor : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primaryColor.withOpacity(0.12)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: selected ? AppTheme.primaryColor : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppTheme.primaryColor : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _detail(String method) {
    String title;
    String desc;
    IconData icon;

    switch (method) {
      case 'qris':
        title = 'QRIS';
        desc =
            '• Buka e-wallet / m-banking\n'
            '• Pilih Scan QR\n'
            '• Scan QRIS lalu bayar sesuai total\n\n'
            '(Ini tampilan simulasi)';
        icon = Icons.qr_code_2_rounded;
        break;
      case 'dana':
        title = 'DANA';
        desc =
            '• Buka aplikasi DANA\n'
            '• Pilih Kirim / Scan\n'
            '• Lakukan pembayaran sesuai total\n\n'
            '(Ini tampilan simulasi)';
        icon = Icons.account_balance_wallet_rounded;
        break;
      case 'shopeepay':
        title = 'ShopeePay';
        desc =
            '• Buka ShopeePay\n'
            '• Pilih Bayar / Scan\n'
            '• Konfirmasi pembayaran\n\n'
            '(Ini tampilan simulasi)';
        icon = Icons.payment_rounded;
        break;
      default:
        title = 'Bayar di Kasir';
        desc =
            '• Tunjukkan pesanan ke kasir\n'
            '• Bayar saat ambil pesanan\n'
            '• Pesanan diproses setelah dikonfirmasi';
        icon = Icons.storefront_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
