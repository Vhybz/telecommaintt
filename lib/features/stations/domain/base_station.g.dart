// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BaseStationImpl _$$BaseStationImplFromJson(Map<String, dynamic> json) =>
    _$BaseStationImpl(
      id: json['id'] as String,
      siteId: json['site_id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      regionId: (json['region_id'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      towerType: json['tower_type'] as String?,
      operator: json['operator'] as String?,
      installationDate: json['installation_date'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$$BaseStationImplToJson(_$BaseStationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'site_id': instance.siteId,
      'name': instance.name,
      'status': instance.status,
      'region_id': instance.regionId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'tower_type': instance.towerType,
      'operator': instance.operator,
      'installation_date': instance.installationDate,
      'created_at': instance.createdAt,
    };
