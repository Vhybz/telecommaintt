import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_log.freezed.dart';
part 'alarm_log.g.dart';

@freezed
abstract class AlarmLog with _$AlarmLog {
  const factory AlarmLog({
    required String id,
    @JsonKey(name: 'station_id') String? stationId,
    @JsonKey(name: 'equipment_id') String? equipmentId,
    String? severity,
    String? description,
    String? status,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'resolved_at') String? resolvedAt,
  }) = _AlarmLog;

  factory AlarmLog.fromJson(Map<String, dynamic> json) => _$AlarmLogFromJson(json);
}
