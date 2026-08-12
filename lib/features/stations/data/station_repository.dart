import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/base_station.dart';

final stationRepositoryProvider = Provider((ref) => StationRepository(Supabase.instance.client));

final stationsProvider = FutureProvider<List<BaseStation>>((ref) async {
  final repository = ref.watch(stationRepositoryProvider);
  try {
    return await repository.getStations();
  } catch (e) {
    return [
      BaseStation(
        id: '1', 
        name: 'Accra Central Hub', 
        siteId: 'GH-ACC-001', 
        status: 'Online', 
        regionId: 1, // Greater Accra
        latitude: 5.6037,
        longitude: -0.1870,
      ),
      BaseStation(
        id: '2', 
        name: 'Kumasi Industrial', 
        siteId: 'GH-KMS-042', 
        status: 'Offline', 
        regionId: 2, // Ashanti
        latitude: 6.6666,
        longitude: -1.6163,
      ),
      BaseStation(
        id: '3', 
        name: 'Takoradi Port', 
        siteId: 'GH-TKD-012', 
        status: 'Online', 
        regionId: 3, // Western
        latitude: 4.8917,
        longitude: -1.7500,
      ),
      BaseStation(
        id: '4', 
        name: 'Tamale North', 
        siteId: 'GH-TML-088', 
        status: 'Online', 
        regionId: 4, // Northern
        latitude: 9.4034,
        longitude: -0.8424,
      ),
    ];
  }
});

class StationRepository {
  final SupabaseClient _client;
  StationRepository(this._client);

  Future<List<BaseStation>> getStations() async {
    final response = await _client.from('base_stations').select();
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
