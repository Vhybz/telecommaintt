import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/kpi_record.dart';

final kpiRepositoryProvider = Provider((ref) => KpiRepository(Supabase.instance.client));

final kpiRecordsProvider = FutureProvider<List<KpiRecord>>((ref) async {
  final repository = ref.watch(kpiRepositoryProvider);
  return await repository.getKpiRecords();
});

class KpiRepository {
  final SupabaseClient _client;
  KpiRepository(this._client);

  Future<List<KpiRecord>> getKpiRecords({String? stationId, int limit = 20}) async {
    var query = _client.from('kpi_records').select();
    
    if (stationId != null) {
      query = query.eq('station_id', stationId);
    }
    
    final response = await query.order('timestamp', ascending: false).limit(limit);
    return (response as List).map((json) => KpiRecord.fromJson(json)).toList();
  }
}
