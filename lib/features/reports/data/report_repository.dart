import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportRepositoryProvider = Provider((ref) => ReportRepository(Supabase.instance.client));

final reportsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(reportRepositoryProvider);
  return await repository.getReports();
});

class ReportRepository {
  final SupabaseClient _client;
  ReportRepository(this._client);

  Future<List<Map<String, dynamic>>> getReports() async {
    final response = await _client
        .from('reports')
        .select('*, base_stations(name), profiles:created_by(full_name)')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<String?> uploadReport(Uint8List bytes, String fileName) async {
    final path = 'reports/$fileName';
    
    await _client.storage.from('reports').uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(contentType: 'application/pdf', upsert: true),
    );

    return _client.storage.from('reports').getPublicUrl(path);
  }

  Future<void> saveReportRecord({
    required String name,
    required String type,
    String? stationId,
    String? fileUrl,
    required String createdBy,
  }) async {
    await _client.from('reports').insert({
      'name': name,
      'type': type,
      'station_id': stationId,
      'file_url': fileUrl,
      'created_by': createdBy,
    });
  }
}
