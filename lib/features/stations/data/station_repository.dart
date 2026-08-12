import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/base_station.dart';

final stationRepositoryProvider = Provider((ref) => StationRepository(Supabase.instance.client));

final stationsProvider = FutureProvider<List<BaseStation>>((ref) async {
  final repository = ref.watch(stationRepositoryProvider);
  return await repository.getStations();
});

class StationRepository {
  final SupabaseClient _client;
  StationRepository(this._client);

  Future<List<BaseStation>> getStations() async {
    final response = await _client.from('base_stations').select().order('name');
    return (response as List).map((json) => BaseStation.fromJson(json)).toList();
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
