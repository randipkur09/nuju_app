class AppConstants {
  // API Endpoints (Replace dengan actual backend URL)
  static const String baseUrl = 'https://api.nujucoffee.com';
  static const String apiVersion = '/api/v1';

  // Assets paths
  static const String logoPath = 'assets/images/logo.png';
  static const String splashPath = 'assets/images/splash.png';

  // Payment methods
  static const List<String> paymentMethods = [
    'qris',
    'ewallet',
    'transfer',
    'cash',
  ];

  static const Map<String, String> paymentMethodLabels = {
    'qris': 'QRIS',
    'ewallet': 'E-Wallet',
    'transfer': 'Transfer Bank',
    'cash': 'Tunai',
  };

  // Order statuses
  static const List<String> orderStatuses = [
    'pending',
    'confirmed',
    'processing',
    'ready',
    'completed',
  ];

  static const Map<String, String> orderStatusLabels = {
    'pending': 'Menunggu',
    'confirmed': 'Dikonfirmasi',
    'processing': 'Diproses',
    'ready': 'Siap Diambil',
    'completed': 'Selesai',
  };

  // User roles
  static const String roleCustomer = 'customer';
  static const String roleBarista = 'barista';
  static const String roleAdmin = 'admin';

  // Product categories
  static const List<String> categories = [
    'all',
    'coffee',
    'non-coffee',
    'snacks',
  ];

  static const Map<String, String> categoryLabels = {
    'all': 'Semua',
    'coffee': 'Kopi',
    'non-coffee': 'Non-Kopi',
    'snacks': 'Snack',
  };

  // Sizes
  static const List<String> sizes = ['S', 'M', 'L'];

  // App strings
  static const String appName = 'Nuju Coffee';
  static const String appTagline = 'Kopi Terbaik untuk Hari Terbaikmu';
}
