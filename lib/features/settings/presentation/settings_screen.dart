import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final primaryColor = ref.watch(primaryColorProvider);

    final coolColors = [
      const Color(0xFF6A1B9A), // Original Purple
      const Color(0xFF2196F3), // Blue
      const Color(0xFF00C48C), // Teal
      const Color(0xFFFF4D4F), // Red
      const Color(0xFFE91E63), // Pink
      const Color(0xFFFFAB00), // Amber
      const Color(0xFF3F51B5), // Indigo
      const Color(0xFF00BCD4), // Cyan
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'Configure your network monitoring preferences',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          
          _buildSettingsSection(
            primaryColor: primaryColor,
            title: 'Appearance',
            children: [
              _buildSettingTile(
                primaryColor: primaryColor,
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: themeMode == ThemeMode.dark ? 'Enabled' : 'Disabled',
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  onChanged: (v) {
                    ref.read(themeModeProvider.notifier).state = 
                      v ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Theme Color', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('Choose a color that fits your style', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: coolColors.map((color) {
                    final isSelected = primaryColor == color;
                    return GestureDetector(
                      onTap: () {
                        ref.read(primaryColorProvider.notifier).state = color;
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected 
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ] : null,
                        ),
                        child: isSelected 
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          _buildSettingsSection(
            primaryColor: primaryColor,
            title: 'General',
            children: [
              _buildSettingTile(
                primaryColor: primaryColor,
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English (Ghana)',
                trailing: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          _buildSettingsSection(
            primaryColor: primaryColor,
            title: 'Notifications',
            children: [
              _buildSettingTile(
                primaryColor: primaryColor,
                icon: Icons.notifications_active_outlined,
                title: 'Push Notifications',
                subtitle: 'Critical alarms only',
                trailing: Switch(value: true, onChanged: (v) {}),
              ),
              _buildSettingTile(
                primaryColor: primaryColor,
                icon: Icons.email_outlined,
                title: 'Email Reports',
                subtitle: 'Weekly summary',
                trailing: Switch(value: true, onChanged: (v) {}),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.go('/signup'),
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({required String title, required List<Widget> children, required Color primaryColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required Color primaryColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: primaryColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: trailing,
    );
  }
}
