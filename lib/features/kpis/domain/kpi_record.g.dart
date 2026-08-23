// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kpi_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KpiRecordImpl _$$KpiRecordImplFromJson(Map<String, dynamic> json) =>
    _$KpiRecordImpl(
      id: json['id'] as String,
      stationId: json['station_id'] as String,
      timestamp: json['timestamp'] as String,
      availability: (json['availability'] as num?)?.toDouble(),
      cssr: (json['cssr'] as num?)?.toDouble(),
      cdr: (json['cdr'] as num?)?.toDouble(),
      rsrp: (json['rsrp'] as num?)?.toDouble(),
      rsrq: (json['rsrq'] as num?)?.toDouble(),
      sinr: (json['sinr'] as num?)?.toDouble(),
      temperature: (json['temperature'] as num?)?.toDouble(),
      voltage: (json['voltage'] as num?)?.toDouble(),
      powerConsumption: (json['power_consumption'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$KpiRecordImplToJson(_$KpiRecordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'station_id': instance.stationId,
      'timestamp': instance.timestamp,
      'availability': instance.availability,
      'cssr': instance.cssr,
      'cdr': instance.cdr,
      'rsrp': instance.rsrp,
      'rsrq': instance.rsrq,
      'sinr': instance.sinr,
      'temperature': instance.temperature,
      'voltage': instance.voltage,
      'power_consumption': instance.powerConsumption,
    };
