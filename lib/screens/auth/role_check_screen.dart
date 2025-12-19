import 'package:flutter/material.dart';
import 'package:nujucoffee/screens/admin/admin_home_screen.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';
import '../../utils/theme.dart';
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
        // Modern loading screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppTheme.lightColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated gradient logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.coffee_maker_outlined,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.8)),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Nuju Coffee',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      foreground: Paint()
                        ..shader = AppTheme.primaryGradient.createShader(
                          const Rect.fromLTWH(0, 0, 200, 70),
                        ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Menyiapkan pengalaman kopi terbaik...',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
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
              return Scaffold(
                backgroundColor: AppTheme.lightColor,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // User avatar with gradient
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: AppTheme.secondaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.secondaryColor.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CircularProgressIndicator(
                        color: AppTheme.accentColor,
                        backgroundColor: AppTheme.lightColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Memuat data pengguna...',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
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