import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          _buildQuickStats(context),
          const SizedBox(height: 24),
          _buildCategoryFilters(),
          const SizedBox(height: 16),
          _buildReportsList(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Network Reports', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(
              'Historical data and performance analysis',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Generate Report'),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          return Column(
            children: [
              _buildSummaryCard(context, 'Last Month', '12 Reports', Icons.history),
              const SizedBox(height: 12),
              _buildSummaryCard(context, 'Scheduled', '4 Reports', Icons.schedule),
              const SizedBox(height: 12),
              _buildSummaryCard(context, 'Failed', '0', Icons.error_outline),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: _buildSummaryCard(context, 'Last Month', '12 Reports', Icons.history)),
            const SizedBox(width: 16),
            Expanded(child: _buildSummaryCard(context, 'Scheduled', '4 Reports', Icons.schedule)),
            const SizedBox(width: 16),
            Expanded(child: _buildSummaryCard(context, 'Failed', '0', Icons.error_outline)),
          ],
        );
      }
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String count, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(title, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = ['All', 'Performance', 'Faults', 'Inventory', 'Security'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: ChoiceChip(
            label: Text(cat),
            selected: cat == 'All',
            onSelected: (val) {},
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildReportsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (context, index) => _buildReportItem(index),
    );
  }

  Widget _buildReportItem(int index) {
    final isPdf = index % 2 == 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isPdf ? Icons.picture_as_pdf : Icons.table_chart,
          color: isPdf ? AppColors.error : AppColors.success,
        ),
        title: Text('Network_Analysis_Q${index + 1}_2026.${isPdf ? "pdf" : "csv"}'),
        subtitle: Text('Generated: Aug ${10 - index}, 2026 • 2.4 MB'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.download), onPressed: () {}),
            IconButton(icon: const Icon(Icons.share), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
