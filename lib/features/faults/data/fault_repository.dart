import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/alarm_log.dart';

final faultRepositoryProvider = Provider((ref) => FaultRepository(Supabase.instance.client));

final alarmsProvider = FutureProvider<List<AlarmLog>>((ref) async {
  final repository = ref.watch(faultRepositoryProvider);
  return await repository.getAlarms();
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
