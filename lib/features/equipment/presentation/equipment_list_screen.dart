import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';
import '../data/equipment_repository.dart';

class EquipmentListScreen extends ConsumerWidget {
  const EquipmentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipmentAsync = ref.watch(equipmentProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          equipmentAsync.when(
            data: (items) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCards(context, items),
                const SizedBox(height: 24),
                _buildInventoryGrid(context, items),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search equipment...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildFilterChip(context, 'All'),
        const SizedBox(width: 8),
        _buildFilterChip(context, 'Routers'),
        const SizedBox(width: 8),
        _buildFilterChip(context, 'Antennas'),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label) {
    bool isSelected = label == 'All';
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {},
      backgroundColor: Theme.of(context).cardColor,
      selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent),
    );
  }

  Widget _buildSummaryCards(BuildContext context, List<Map<String, dynamic>> items) {
    final active = items.where((i) => i['status'] == 'Active').length;
    final maintenance = items.where((i) => i['status'] == 'Maintenance').length;

    return Row(
      children: [
        Expanded(child: _buildStatCard(context, 'Total Items', items.length.toString(), Icons.inventory_2, Theme.of(context).colorScheme.primary)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(context, 'Active', active.toString(), Icons.check_circle, AppColors.success)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard(context, 'Maintenance', maintenance.toString(), Icons.build, AppColors.warning)),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryGrid(BuildContext context, List<Map<String, dynamic>> items) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Text('No equipment found in inventory.'),
        ),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > 1200 ? 4 : (constraints.maxWidth > 800 ? 3 : 2);
      double aspectRatio = constraints.maxWidth < 600 ? 0.75 : 0.85;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: aspectRatio,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => _buildEquipmentCard(context, items[index]),
      );
    });
  }

  Widget _buildEquipmentCard(BuildContext context, Map<String, dynamic> item) {
    final name = item['model'] ?? item['equipment_types']?['name'] ?? 'Unknown Item';
    final status = item['status'] ?? 'Active';
    final statusColor = status == 'Active' ? AppColors.success : AppColors.warning;
    final site = item['base_stations']?['name'] ?? 'Unknown Site';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
              child: Center(
                child: Lottie.network(
                  'https://lottie.host/9f538350-591b-419b-980b-226027a08f65/S7Scl1YnTM.json',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                    Icon(Icons.settings_input_component, size: 40, color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('SN: ${item['serial_number'] ?? 'N/A'}', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text('Site: $site', style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
