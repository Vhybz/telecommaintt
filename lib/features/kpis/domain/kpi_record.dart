import 'package:freezed_annotation/freezed_annotation.dart';

part 'kpi_record.freezed.dart';
part 'kpi_record.g.dart';

@freezed
abstract class KpiRecord with _$KpiRecord {
  const factory KpiRecord({
    required String id,
    @JsonKey(name: 'station_id') required String stationId,
    required String timestamp,
    double? availability,
    double? cssr,
    double? cdr,
    double? rsrp,
    double? rsrq,
    double? sinr,
    double? temperature,
    double? voltage,
    @JsonKey(name: 'power_consumption') double? powerConsumption,
  }) = _KpiRecord;

  factory KpiRecord.fromJson(Map<String, dynamic> json) => _$KpiRecordFromJson(json);
}
