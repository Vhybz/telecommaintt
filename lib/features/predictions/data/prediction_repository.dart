import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/prediction.dart';

final predictionRepositoryProvider = Provider((ref) => PredictionRepository(Supabase.instance.client));

final predictionsProvider = FutureProvider<List<Prediction>>((ref) async {
  final repository = ref.watch(predictionRepositoryProvider);
  try {
    return await repository.getPredictions();
  } catch (e) {
    // Return mock data for development if Supabase fails
    return [
      Prediction(
        id: '1',
        stationId: 'GH-ACC-001',
        faultType: 'Hardware Failure',
        probability: 0.85,
        riskLevel: 'High',
        recommendedAction: 'Send technician to Accra hub for module replacement.',
        createdAt: DateTime.now().toIso8601String(),
      ),
      Prediction(
        id: '2',
        stationId: 'GH-KMS-042',
        faultType: 'Signal Degradation',
        probability: 0.45,
        riskLevel: 'Medium',
        recommendedAction: 'Monitor signal logs in Ashanti region for the next 24 hours.',
        createdAt: DateTime.now().toIso8601String(),
      ),
      Prediction(
        id: '3',
        stationId: 'GH-TKD-012',
        faultType: 'Power Overload',
        probability: 0.15,
        riskLevel: 'Low',
        recommendedAction: 'Routine check scheduled for next month in Takoradi.',
        createdAt: DateTime.now().toIso8601String(),
      ),
    ];
  }
});

class PredictionRepository {
  final SupabaseClient _client;
  PredictionRepository(this._client);

  Future<List<Prediction>> getPredictions() async {
    final response = await _client.from('predictions').select().order('created_at', ascending: false);
    return (response as List).map((json) => Prediction.fromJson(json)).toList();
  }
}
