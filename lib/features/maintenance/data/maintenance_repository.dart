import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final maintenanceRepositoryProvider = Provider((ref) => MaintenanceRepository(Supabase.instance.client));

final maintenanceTasksProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(maintenanceRepositoryProvider);
  return await repository.getMaintenanceTasks();
});

class MaintenanceRepository {
  final SupabaseClient _client;
  MaintenanceRepository(this._client);

  Future<List<Map<String, dynamic>>> getMaintenanceTasks() async {
    final response = await _client
        .from('maintenance_tasks')
        .select('*, base_stations(name), profiles(full_name)')
        .order('scheduled_date', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }
}
