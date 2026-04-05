import 'package:flutter/material.dart';
import 'package:mubit/core/theme/app_theme.dart';
import 'package:mubit/features/habit_tracker/ui/istiqomah_screen.dart';
import 'package:mubit/features/settings/ui/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.backgroundWhite,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Mubit',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _DrawerItem(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            isSelected: true,
            onTap: () => Navigator.pop(context),
          ),
          _DrawerItem(
            icon: Icons.bar_chart_rounded,
            label: 'Grafik Istiqomah',
            onTap: () {
               Navigator.pop(context); // Close drawer
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const IstiqomahScreen()),
               );
            },
          ),
          _DrawerItem(
            icon: Icons.settings_suggest_rounded,
            label: 'Pengaturan',
            onTap: () {
               Navigator.pop(context); // Close drawer
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const SettingsScreen()),
               );
            },
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryGreen.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? AppTheme.primaryGreen : Colors.grey[700],
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryGreen : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
