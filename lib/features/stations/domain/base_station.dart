import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_station.freezed.dart';
part 'base_station.g.dart';

@freezed
abstract class BaseStation with _$BaseStation {
  const factory BaseStation({
    required String id,
    @JsonKey(name: 'site_id') required String siteId,
    required String name,
    required String status,
    @JsonKey(name: 'region_id') int? regionId,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'tower_type') String? towerType,
    String? operator,
    @JsonKey(name: 'installation_date') String? installationDate,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _BaseStation;

  factory BaseStation.fromJson(Map<String, dynamic> json) => _$BaseStationFromJson(json);
}
