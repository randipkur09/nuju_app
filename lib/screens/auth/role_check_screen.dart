import 'package:flutter/material.dart';
import 'package:nujucoffee/screens/admin/admin_home_screen.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import 'login_screen.dart';
import '../customer/customer_home_screen.dart';
import '../barista/barista_home_screen.dart';
import '../admin/admin_dashboard_screen.dart';

class RoleCheckScreen extends StatelessWidget {
  const RoleCheckScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<AuthService>().authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User not logged in
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // User logged in, check role
        return FutureBuilder(
          future: context.read<AuthService>().getCurrentUserData(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final userData = userSnapshot.data;
            if (userData == null) {
              return const LoginScreen();
            }

            // Navigate based on role
            switch (userData.role) {
              case AppConstants.roleCustomer:
                return CustomerHomeScreen();
              case AppConstants.roleBarista:
                return const BaristaHomeScreen();
              case AppConstants.roleAdmin:
                return const AdminHomeScreen();
              default:
                return const LoginScreen();
            }
          },
        );
      },
    );
  }
}
