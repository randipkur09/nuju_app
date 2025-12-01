import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        elevation: 0,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.currentUser;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Container(
                  color: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user?.name ?? 'User',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user?.email ?? 'email@example.com',
                          style: const TextStyle(
                            color: Color(0xFFF5E6D3),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Info
                      _buildInfoCard(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: user?.email ?? '-',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.phone_outlined,
                        label: 'Telepon',
                        value: user?.phone ?? '-',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        icon: Icons.badge_outlined,
                        label: 'Role',
                        value: user?.role ?? '-',
                      ),
                      const SizedBox(height: 32),
                      // Menu Items
                      _buildMenuItem(
                        icon: Icons.shopping_bag_outlined,
                        label: 'Pesanan Saya',
                        onTap: () => context.go('/customer/order-status'),
                      ),
                      const Divider(height: 16),
                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        label: 'Alamat',
                        onTap: () {},
                      ),
                      const Divider(height: 16),
                      _buildMenuItem(
                        icon: Icons.payment_outlined,
                        label: 'Metode Pembayaran',
                        onTap: () {},
                      ),
                      const Divider(height: 16),
                      _buildMenuItem(
                        icon: Icons.settings_outlined,
                        label: 'Pengaturan',
                        onTap: () {},
                      ),
                      const SizedBox(height: 32),
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE74C3C),
                          ),
                          onPressed: () {
                            authProvider.logout().then((_) {
                              context.go('/login');
                            });
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(label),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}
