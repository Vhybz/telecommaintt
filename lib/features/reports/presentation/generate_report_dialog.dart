import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../stations/data/station_repository.dart';
import '../data/report_repository.dart';
import '../../../services/report_service.dart';
import '../../auth/data/auth_repository.dart';

class GenerateReportDialog extends ConsumerStatefulWidget {
  const GenerateReportDialog({super.key});

  @override
  ConsumerState<GenerateReportDialog> createState() => _GenerateReportDialogState();
}

class _GenerateReportDialogState extends ConsumerState<GenerateReportDialog> {
  String? _selectedStationId;
  String _selectedType = 'Performance';
  bool _isLoading = false;

  final List<String> _reportTypes = ['Performance', 'Faults', 'Inventory', 'Security'];

  Future<void> _generate() async {
    setState(() => _isLoading = true);
    
    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) throw Exception('User not logged in');

      final stations = await ref.read(stationRepositoryProvider).getStations();
      final station = stations.firstWhere((s) => s.id == _selectedStationId);
      
      // For demo, we'll use some mock KPI data
      final mockData = {
        'availability': 99.5,
        'cssr': 98.2,
        'cdr': 0.15,
      };

      final pdfBytes = await ReportService().generateStationReport(station.name, mockData);
      
      final fileName = 'report_${station.siteId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final fileUrl = await ref.read(reportRepositoryProvider).uploadReport(pdfBytes, fileName);

      await ref.read(reportRepositoryProvider).saveReportRecord(
        name: 'Report for ${station.name}',
        type: _selectedType,
        stationId: station.id,
        fileUrl: fileUrl,
        createdBy: user.id,
      );

      ref.invalidate(reportsProvider);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report generated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(stationsProvider);

    return AlertDialog(
      title: const Text('Generate Network Report'),
      content: _isLoading 
        ? const SizedBox(
            height: 100, 
            child: Center(child: CircularProgressIndicator())
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              stationsAsync.when(
                data: (stations) => DropdownButtonFormField<String>(
                  value: _selectedStationId,
                  decoration: const InputDecoration(labelText: 'Select Base Station'),
                  items: stations.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                  onChanged: (v) => setState(() => _selectedStationId = v),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Error loading stations'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'Report Type'),
                items: _reportTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
            ],
          ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _selectedStationId == null || _isLoading ? null : _generate, 
          child: const Text('Generate'),
        ),
      ],
    );
  }
}
