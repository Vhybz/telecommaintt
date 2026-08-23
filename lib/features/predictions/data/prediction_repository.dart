import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/prediction.dart';

final predictionRepositoryProvider = Provider((ref) => PredictionRepository(Supabase.instance.client));

final predictionsProvider = FutureProvider<List<Prediction>>((ref) async {
  final repository = ref.watch(predictionRepositoryProvider);
  return await repository.getPredictions();
});

class PredictionRepository {
  final SupabaseClient _client;
  PredictionRepository(this._client);

  Future<List<Prediction>> getPredictions() async {
    final response = await _client.from('predictions').select().order('created_at', ascending: false);
    return (response as List).map((json) => Prediction.fromJson(json)).toList();
  }
}
