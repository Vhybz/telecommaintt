import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/report_repository.dart';
import 'generate_report_dialog.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(reportsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          reportsAsync.when(
            data: (reports) => _buildQuickStats(context, reports),
            loading: () => const LinearProgressIndicator(),
            error: (error, stack) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 24),
          _buildCategoryFilters(),
          const SizedBox(height: 16),
          reportsAsync.when(
            data: (reports) {
              final filteredReports = _selectedFilter == 'All'
                  ? reports
                  : reports.where((r) => r['type'] == _selectedFilter).toList();
              return _buildReportsList(filteredReports);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
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
          onPressed: () => showDialog(
            context: context,
            builder: (context) => const GenerateReportDialog(),
          ),
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text('Generate Report'),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, List<Map<String, dynamic>> reports) {
    final lastRun = reports.isEmpty ? 'N/A' : DateFormat('MMM dd').format(DateTime.parse(reports.first['created_at']));

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 700) {
          return Column(
            children: [
              _buildSummaryCard(context, 'Total Generated', '${reports.length} Reports', Icons.history),
              const SizedBox(height: 12),
              _buildSummaryCard(context, 'Scheduled', '0 Reports', Icons.schedule),
              const SizedBox(height: 12),
              _buildSummaryCard(context, 'Last Run', lastRun, Icons.timer),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: _buildSummaryCard(context, 'Total Generated', '${reports.length} Reports', Icons.history)),
            const SizedBox(width: 16),
            Expanded(child: _buildSummaryCard(context, 'Scheduled', '0 Reports', Icons.schedule)),
            const SizedBox(width: 16),
            Expanded(child: _buildSummaryCard(context, 'Last Run', lastRun, Icons.timer)),
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
            selected: _selectedFilter == cat,
            onSelected: (val) {
              if (val) setState(() => _selectedFilter = cat);
            },
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildReportsList(List<Map<String, dynamic>> reports) {
    if (reports.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Column(
            children: [
              Icon(Icons.description_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text('No reports found.', style: TextStyle(color: Colors.grey)),
              Text('Adjust your filter or generate a new report.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        final date = DateTime.parse(report['created_at']);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.picture_as_pdf, color: Colors.red),
            ),
            title: Text(report['name'] ?? 'Untitled Report', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              'Generated on ${DateFormat('MMM dd, yyyy HH:mm').format(date)} • ${report['type']}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.download_rounded),
              onPressed: () async {
                final url = report['file_url'];
                if (url != null && await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not open report URL')),
                    );
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }
}
