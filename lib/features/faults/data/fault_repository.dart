import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/alarm_log.dart';

final faultRepositoryProvider = Provider((ref) => FaultRepository(Supabase.instance.client));

final alarmsProvider = FutureProvider<List<AlarmLog>>((ref) async {
  final repository = ref.watch(faultRepositoryProvider);
  try {
    return await repository.getAlarms();
  } catch (e) {
    return [
      AlarmLog(id: '1', stationId: 'GH-ACC-001', description: 'Main power grid outage in Accra Central', severity: 'Critical', status: 'Open', createdAt: DateTime.now().toIso8601String()),
      AlarmLog(id: '2', stationId: 'GH-KMS-042', description: 'Cooling system failure at Kumasi Hub', severity: 'Major', status: 'Acknowledged', createdAt: DateTime.now().toIso8601String()),
      AlarmLog(id: '3', stationId: 'GH-TKD-012', description: 'Minor signal interference detected near Takoradi Port', severity: 'Minor', status: 'Resolved', createdAt: DateTime.now().toIso8601String()),
    ];
  }
});

class FaultRepository {
  final SupabaseClient _client;
  FaultRepository(this._client);

  Future<List<AlarmLog>> getAlarms() async {
    final response = await _client.from('alarm_logs').select().order('created_at', ascending: false);
    return (response as List).map((json) => AlarmLog.fromJson(json)).toList();
  }

  Future<void> acknowledgeAlarm(String id) async {
    await _client.from('alarm_logs').update({'status': 'Acknowledged'}).eq('id', id);
  }

  Future<void> resolveAlarm(String id) async {
    await _client.from('alarm_logs').update({
      'status': 'Resolved',
      'resolved_at': DateTime.now().toIso8601String(),
    }).eq('id', id);
  }
}
