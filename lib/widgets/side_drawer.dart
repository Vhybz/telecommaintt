import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telecomf/core/theme/app_colors.dart';
import 'package:telecomf/core/theme/theme_provider.dart';
import 'package:telecomf/features/auth/data/auth_repository.dart';

class SideDrawer extends ConsumerWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const SideDrawer({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final profileAsync = ref.watch(userProfileProvider);

    return Drawer(
      backgroundColor: Theme.of(context).cardColor,
      child: Column(
        children: [
          // Header Section
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
            ),
            child: profileAsync.when(
              data: (profile) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor,
                    backgroundImage: profile?['avatar_url'] != null 
                        ? NetworkImage(profile!['avatar_url']) 
                        : null,
                    child: profile?['avatar_url'] == null 
                        ? const Icon(Icons.person, color: Colors.white, size: 30)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    profile?['full_name'] ?? 'User',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    profile?['roles']?['name'] ?? 'Staff',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Icon(Icons.error_outline),
            ),
          ),
          
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildNavItem(context, ref, Icons.dashboard_outlined, Icons.dashboard, 'Dashboard', 0),
                _buildNavItem(context, ref, Icons.router_outlined, Icons.router, 'Base Stations', 1),
                _buildNavItem(context, ref, Icons.warning_amber_outlined, Icons.warning, 'Alerts', 4),
                _buildNavItem(context, ref, Icons.online_prediction_outlined, Icons.online_prediction, 'Predictions', 5),
                _buildNavItem(context, ref, Icons.add_chart_outlined, Icons.add_chart, 'Run Prediction', 9),
                _buildNavItem(context, ref, Icons.description_outlined, Icons.description, 'Reports', 7),
                _buildNavItem(context, ref, Icons.build_outlined, Icons.build, 'Maintenance', 6),
                _buildNavItem(context, ref, Icons.settings_outlined, Icons.settings, 'Settings', 8),
                _buildNavItem(context, ref, Icons.person_outline, Icons.person, 'Profile', 10),
              ],
            ),
          ),

          const Divider(),
          
          // Logout Button
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Logout', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            onTap: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, WidgetRef ref, IconData icon, IconData selectedIcon, String label, int index) {
    final primaryColor = ref.watch(primaryColorProvider);
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ListTile(
        selected: isSelected,
        selectedTileColor: primaryColor.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          isSelected ? selectedIcon : icon,
          color: isSelected ? primaryColor : Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryColor : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.pop(context); // Close drawer
          onDestinationSelected(index);
        },
      ),
    );
  }
}
