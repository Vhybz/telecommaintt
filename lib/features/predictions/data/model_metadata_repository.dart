import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/model_metadata.dart';

final modelMetadataRepositoryProvider = Provider((ref) => ModelMetadataRepository());

final modelMetadataProvider = FutureProvider<ModelMetadata>((ref) async {
  final repository = ref.watch(modelMetadataRepositoryProvider);
  return await repository.getModelMetadata();
});

class ModelMetadataRepository {
  Future<ModelMetadata> getModelMetadata() async {
    final String response = await rootBundle.loadString('backend/model_metadata.json');
    final data = await json.decode(response);
    return ModelMetadata.fromJson(data);
  }
}
