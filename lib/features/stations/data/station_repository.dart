import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/base_station.dart';

final stationRepositoryProvider = Provider((ref) => StationRepository(Supabase.instance.client));

final stationsProvider = FutureProvider<List<BaseStation>>((ref) async {
  final repository = ref.watch(stationRepositoryProvider);
  return await repository.getStations();
});

final regionsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(stationRepositoryProvider);
  return await repository.getRegions();
});

class StationRepository {
  final SupabaseClient _client;
  StationRepository(this._client);

  Future<List<BaseStation>> getStations() async {
    final response = await _client.from('base_stations').select().order('name');
    return (response as List).map((json) => BaseStation.fromJson(json)).toList();
  }

  Future<List<Map<String, dynamic>>> getRegions() async {
    final response = await _client.from('regions').select().order('name');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<BaseStation> getStationById(String id) async {
    final response = await _client.from('base_stations').select().eq('id', id).single();
    return BaseStation.fromJson(response);
  }

  Future<void> createStation(BaseStation station) async {
    await _client.from('base_stations').insert(station.toJson());
  }

  Future<void> updateStation(BaseStation station) async {
    await _client.from('base_stations').update(station.toJson()).eq('id', station.id);
  }

  Future<void> deleteStation(String id) async {
    await _client.from('base_stations').delete().eq('id', id);
  }
}
