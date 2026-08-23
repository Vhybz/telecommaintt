// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AlarmLogImpl _$$AlarmLogImplFromJson(Map<String, dynamic> json) =>
    _$AlarmLogImpl(
      id: json['id'] as String,
      stationId: json['station_id'] as String?,
      equipmentId: json['equipment_id'] as String?,
      severity: json['severity'] as String?,
      description: json['description'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      resolvedAt: json['resolved_at'] as String?,
    );

Map<String, dynamic> _$$AlarmLogImplToJson(_$AlarmLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'station_id': instance.stationId,
      'equipment_id': instance.equipmentId,
      'severity': instance.severity,
      'description': instance.description,
      'status': instance.status,
      'created_at': instance.createdAt,
      'resolved_at': instance.resolvedAt,
    };
