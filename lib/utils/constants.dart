class AppConstants {
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String menuCollection = 'menu';
  static const String ordersCollection = 'orders';

  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleBarista = 'barista';
  static const String roleCustomer = 'customer';

  // Order Status
  static const String statusPending = 'pending';
  static const String statusProcessing = 'processing';
  static const String statusReady = 'ready';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  // Default Admin Credentials
  static const String defaultAdminEmail = 'admin@nujucoffee.com';
  static const String defaultAdminPassword = 'Admin123!';
}
