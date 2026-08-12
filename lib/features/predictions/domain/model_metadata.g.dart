// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModelMetadataImpl _$$ModelMetadataImplFromJson(Map<String, dynamic> json) =>
    _$ModelMetadataImpl(
      modelName: json['model_name'] as String,
      version: json['version'] as String,
      trainedOn: json['trained_on'] as String,
      dataset: json['dataset'] as String,
      nSamplesOriginal: (json['n_samples_original'] as num).toInt(),
      nSamplesSmote: (json['n_samples_smote'] as num).toInt(),
      nFeatures: (json['n_features'] as num).toInt(),
      classes: (json['classes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      nClasses: (json['n_classes'] as num).toInt(),
      hyperparameters: json['hyperparameters'] as Map<String, dynamic>,
      preprocessing: json['preprocessing'] as Map<String, dynamic>,
      cvResults: json['cv_results'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$ModelMetadataImplToJson(_$ModelMetadataImpl instance) =>
    <String, dynamic>{
      'model_name': instance.modelName,
      'version': instance.version,
      'trained_on': instance.trainedOn,
      'dataset': instance.dataset,
      'n_samples_original': instance.nSamplesOriginal,
      'n_samples_smote': instance.nSamplesSmote,
      'n_features': instance.nFeatures,
      'classes': instance.classes,
      'n_classes': instance.nClasses,
      'hyperparameters': instance.hyperparameters,
      'preprocessing': instance.preprocessing,
      'cv_results': instance.cvResults,
    };
