// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PredictionImpl _$$PredictionImplFromJson(Map<String, dynamic> json) =>
    _$PredictionImpl(
      id: json['id'] as String,
      stationId: json['station_id'] as String?,
      equipmentId: json['equipment_id'] as String?,
      faultType: json['fault_type'] as String,
      probability: (json['probability'] as num).toDouble(),
      riskLevel: json['risk_level'] as String,
      recommendedAction: json['recommended_action'] as String?,
      dcrCssrRatio: (json['dcr_cssr_ratio'] as num?)?.toDouble(),
      tpPrbEfficiency: (json['tp_prb_efficiency'] as num?)?.toDouble(),
      availXCssr: (json['avail_x_cssr'] as num?)?.toDouble(),
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$PredictionImplToJson(_$PredictionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'station_id': instance.stationId,
      'equipment_id': instance.equipmentId,
      'fault_type': instance.faultType,
      'probability': instance.probability,
      'risk_level': instance.riskLevel,
      'recommended_action': instance.recommendedAction,
      'dcr_cssr_ratio': instance.dcrCssrRatio,
      'tp_prb_efficiency': instance.tpPrbEfficiency,
      'avail_x_cssr': instance.availXCssr,
      'created_at': instance.createdAt,
    };
