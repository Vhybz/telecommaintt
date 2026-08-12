import 'package:freezed_annotation/freezed_annotation.dart';

part 'prediction.freezed.dart';
part 'prediction.g.dart';

@freezed
abstract class Prediction with _$Prediction {
  const factory Prediction({
    required String id,
    @JsonKey(name: 'station_id') String? stationId,
    @JsonKey(name: 'equipment_id') String? equipmentId,
    @JsonKey(name: 'fault_type') required String faultType,
    required double probability,
    @JsonKey(name: 'risk_level') required String riskLevel,
    @JsonKey(name: 'recommended_action') String? recommendedAction,
    @JsonKey(name: 'dcr_cssr_ratio') double? dcrCssrRatio,
    @JsonKey(name: 'tp_prb_efficiency') double? tpPrbEfficiency,
    @JsonKey(name: 'avail_x_cssr') double? availXCssr,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _Prediction;

  factory Prediction.fromJson(Map<String, dynamic> json) => _$PredictionFromJson(json);
}
