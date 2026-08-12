import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:telecomf/core/theme/app_colors.dart';
import 'package:telecomf/core/theme/theme_provider.dart';
import 'package:telecomf/features/auth/data/auth_repository.dart';

class SideNavigationRail extends ConsumerWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const SideNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final profileAsync = ref.watch(userProfileProvider);

    return Container(
      width: MediaQuery.of(context).size.width > 1200 ? 260 : 80,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          right: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MediaQuery.of(context).size.width > 1200 ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.cell_tower, color: primaryColor, size: 28),
                ),
                if (MediaQuery.of(context).size.width > 1200) ...[
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Telecom',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Predictive Maintenance',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
          
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
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

          // User Profile Section
          if (MediaQuery.of(context).size.width > 1200)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () => onDestinationSelected(10),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: profileAsync.when(
                    data: (profile) => Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: primaryColor,
                          backgroundImage: profile?['avatar_url'] != null 
                              ? NetworkImage(profile!['avatar_url']) 
                              : null,
                          child: profile?['avatar_url'] == null 
                              ? const Icon(Icons.person, color: Colors.white, size: 24)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                profile?['full_name'] ?? 'User',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                profile?['roles']?['name'] ?? 'Staff',
                                style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    loading: () => const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                    error: (_, error) => const Icon(Icons.error_outline, size: 20),
                  ),
                ),
              ),
            ),
            
          // Logout Button
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            leading: const Icon(Icons.logout, color: AppColors.error, size: 20),
            title: MediaQuery.of(context).size.width > 1200 
                ? const Text('Logout', style: TextStyle(color: AppColors.error, fontSize: 14)) 
                : null,
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
    final isExtended = MediaQuery.of(context).size.width > 1200;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: InkWell(
        onTap: () => onDestinationSelected(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 12, 
            horizontal: isExtended ? 16 : 0,
          ),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: isExtended ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? primaryColor : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 22,
              ),
              if (isExtended) ...[
                const SizedBox(width: 16),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? primaryColor : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
