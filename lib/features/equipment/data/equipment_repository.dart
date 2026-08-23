import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final equipmentRepositoryProvider = Provider((ref) => EquipmentRepository(Supabase.instance.client));

final equipmentProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(equipmentRepositoryProvider);
  return await repository.getEquipment();
});

class EquipmentRepository {
  final SupabaseClient _client;
  EquipmentRepository(this._client);

  Future<List<Map<String, dynamic>>> getEquipment() async {
    final response = await _client
        .from('equipment')
        .select('*, base_stations(name), equipment_types(name)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
}
