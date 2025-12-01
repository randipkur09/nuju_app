import 'package:intl/intl.dart';

class Formatters {
  // Format currency to Rupiah
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Format date to readable format
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
    return formatter.format(date);
  }

  // Format time to readable format
  static String formatTime(DateTime date) {
    final formatter = DateFormat('HH:mm', 'id_ID');
    return formatter.format(date);
  }

  // Format date and time together
  static String formatDateTime(DateTime date) {
    final formatter = DateFormat('dd MMMM yyyy - HH:mm', 'id_ID');
    return formatter.format(date);
  }

  // Get relative time (e.g., "2 hours ago")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return formatDate(date);
    }
  }

  // Format phone number
  static String formatPhone(String phone) {
    if (phone.length < 10) return phone;
    return '+62 ${phone.substring(1)}';
  }
}
