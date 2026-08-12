import 'package:freezed_annotation/freezed_annotation.dart';

part 'alarm_log.freezed.dart';
part 'alarm_log.g.dart';

@freezed
abstract class AlarmLog with _$AlarmLog {
  const factory AlarmLog({
    required String id,
    @JsonKey(name: 'station_id') required String stationId,
    @JsonKey(name: 'equipment_id') String? equipmentId,
    required String severity,
    required String description,
    required String status,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'resolved_at') String? resolvedAt,
  }) = _AlarmLog;

  factory AlarmLog.fromJson(Map<String, dynamic> json) => _$AlarmLogFromJson(json);
}
