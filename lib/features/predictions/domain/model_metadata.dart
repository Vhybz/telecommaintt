import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_metadata.freezed.dart';
part 'model_metadata.g.dart';

@freezed
abstract class ModelMetadata with _$ModelMetadata {
  const factory ModelMetadata({
    @JsonKey(name: 'model_name') required String modelName,
    required String version,
    @JsonKey(name: 'trained_on') required String trainedOn,
    required String dataset,
    @JsonKey(name: 'n_samples_original') required int nSamplesOriginal,
    @JsonKey(name: 'n_samples_smote') required int nSamplesSmote,
    @JsonKey(name: 'n_features') required int nFeatures,
    required List<String> classes,
    @JsonKey(name: 'n_classes') required int nClasses,
    required Map<String, dynamic> hyperparameters,
    required Map<String, dynamic> preprocessing,
    @JsonKey(name: 'cv_results') required Map<String, dynamic> cvResults,
  }) = _ModelMetadata;

  factory ModelMetadata.fromJson(Map<String, dynamic> json) => _$ModelMetadataFromJson(json);
}
