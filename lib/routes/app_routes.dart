import 'package:go_router/go_router.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/customer/home_screen.dart';
import '../screens/customer/menu_screen.dart';
import '../screens/customer/product_detail_screen.dart';
import '../screens/customer/cart_screen.dart';
import '../screens/customer/checkout_screen.dart';
import '../screens/customer/order_status_screen.dart';
import '../screens/customer/favorites_screen.dart';
import '../screens/customer/profile_screen.dart';
import '../screens/barista/barista_dashboard_screen.dart';
import '../screens/barista/barista_order_list_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/admin/admin_menu_screen.dart';
import '../screens/admin/admin_report_screen.dart';
import '../screens/admin/admin_accounts_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String customerHome = '/customer/home';
  static const String menu = '/customer/menu';
  static const String productDetail = '/customer/product/:id';
  static const String cart = '/customer/cart';
  static const String checkout = '/customer/checkout';
  static const String orderStatus = '/customer/order-status';
  static const String favorites = '/customer/favorites';
  static const String profile = '/customer/profile';
  static const String baristaDashboard = '/barista';
  static const String baristaOrderList = '/barista/orders';
  static const String adminDashboard = '/admin';
  static const String adminMenu = '/admin/menu';
  static const String adminReport = '/admin/report';
  static const String adminAccounts = '/admin/accounts';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      // Customer Routes
      GoRoute(
        path: customerHome,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: menu,
        builder: (context, state) => const MenuScreen(),
      ),
      GoRoute(
        path: productDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailScreen(productId: id);
        },
      ),
      GoRoute(
        path: cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: orderStatus,
        builder: (context, state) => const OrderStatusScreen(),
      ),
      GoRoute(
        path: favorites,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      // Barista Routes
      GoRoute(
        path: baristaDashboard,
        builder: (context, state) => const BaristaDashboardScreen(),
      ),
      GoRoute(
        path: baristaOrderList,
        builder: (context, state) => const BaristaOrderListScreen(),
      ),
      // Admin Routes
      GoRoute(
        path: adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: adminMenu,
        builder: (context, state) => const AdminMenuScreen(),
      ),
      GoRoute(
        path: adminReport,
        builder: (context, state) => const AdminReportScreen(),
      ),
      GoRoute(
        path: adminAccounts,
        builder: (context, state) => const AdminAccountsScreen(),
      ),
    ],
  );
}
