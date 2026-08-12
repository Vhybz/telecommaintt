import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/fault_repository.dart';
import '../domain/alarm_log.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/skeleton_loader.dart';

class FaultListScreen extends ConsumerWidget {
  const FaultListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmsAsync = ref.watch(alarmsProvider);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: alarmsAsync.when(
            data: (alarms) => _buildAlarmList(alarms),
            loading: () => const ListSkeleton(),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
    );
  }

  Widget _buildAlarmList(List<AlarmLog> alarms) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: alarms.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final alarm = alarms[index];
        return _buildAlarmTile(context, alarm);
      },
    );
  }

  Widget _buildAlarmTile(BuildContext context, AlarmLog alarm) {
    Color severityColor = _getSeverityColor(alarm.severity);
    final date = DateTime.parse(alarm.createdAt);

    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: severityColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.warning_amber, color: severityColor),
        ),
        title: Text(alarm.description, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Station ID: ${alarm.stationId}'),
            Text(DateFormat('MMM dd, yyyy HH:mm').format(date), style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getStatusColor(alarm.status).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            alarm.status,
            style: TextStyle(color: _getStatusColor(alarm.status), fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Critical': return AppColors.critical;
      case 'Major': return AppColors.error;
      case 'Minor': return AppColors.warning;
      default: return Colors.blue;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open': return AppColors.error;
      case 'Acknowledged': return AppColors.warning;
      case 'Resolved': return AppColors.success;
      default: return Colors.grey;
    }
  }
}
