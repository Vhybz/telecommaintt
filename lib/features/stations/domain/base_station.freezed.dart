// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_station.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BaseStation _$BaseStationFromJson(Map<String, dynamic> json) {
  return _BaseStation.fromJson(json);
}

/// @nodoc
mixin _$BaseStation {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'site_id')
  String get siteId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'region_id')
  int? get regionId => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'tower_type')
  String? get towerType => throw _privateConstructorUsedError;
  String? get operator => throw _privateConstructorUsedError;
  @JsonKey(name: 'installation_date')
  String? get installationDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BaseStation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BaseStation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseStationCopyWith<BaseStation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseStationCopyWith<$Res> {
  factory $BaseStationCopyWith(
    BaseStation value,
    $Res Function(BaseStation) then,
  ) = _$BaseStationCopyWithImpl<$Res, BaseStation>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'site_id') String siteId,
    String name,
    String status,
    @JsonKey(name: 'region_id') int? regionId,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'tower_type') String? towerType,
    String? operator,
    @JsonKey(name: 'installation_date') String? installationDate,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$BaseStationCopyWithImpl<$Res, $Val extends BaseStation>
    implements $BaseStationCopyWith<$Res> {
  _$BaseStationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseStation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? siteId = null,
    Object? name = null,
    Object? status = null,
    Object? regionId = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? towerType = freezed,
    Object? operator = freezed,
    Object? installationDate = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            siteId: null == siteId
                ? _value.siteId
                : siteId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            regionId: freezed == regionId
                ? _value.regionId
                : regionId // ignore: cast_nullable_to_non_nullable
                      as int?,
            latitude: freezed == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            longitude: freezed == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            towerType: freezed == towerType
                ? _value.towerType
                : towerType // ignore: cast_nullable_to_non_nullable
                      as String?,
            operator: freezed == operator
                ? _value.operator
                : operator // ignore: cast_nullable_to_non_nullable
                      as String?,
            installationDate: freezed == installationDate
                ? _value.installationDate
                : installationDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BaseStationImplCopyWith<$Res>
    implements $BaseStationCopyWith<$Res> {
  factory _$$BaseStationImplCopyWith(
    _$BaseStationImpl value,
    $Res Function(_$BaseStationImpl) then,
  ) = __$$BaseStationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'site_id') String siteId,
    String name,
    String status,
    @JsonKey(name: 'region_id') int? regionId,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'tower_type') String? towerType,
    String? operator,
    @JsonKey(name: 'installation_date') String? installationDate,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$BaseStationImplCopyWithImpl<$Res>
    extends _$BaseStationCopyWithImpl<$Res, _$BaseStationImpl>
    implements _$$BaseStationImplCopyWith<$Res> {
  __$$BaseStationImplCopyWithImpl(
    _$BaseStationImpl _value,
    $Res Function(_$BaseStationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BaseStation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? siteId = null,
    Object? name = null,
    Object? status = null,
    Object? regionId = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? towerType = freezed,
    Object? operator = freezed,
    Object? installationDate = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$BaseStationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        siteId: null == siteId
            ? _value.siteId
            : siteId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        regionId: freezed == regionId
            ? _value.regionId
            : regionId // ignore: cast_nullable_to_non_nullable
                  as int?,
        latitude: freezed == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        longitude: freezed == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        towerType: freezed == towerType
            ? _value.towerType
            : towerType // ignore: cast_nullable_to_non_nullable
                  as String?,
        operator: freezed == operator
            ? _value.operator
            : operator // ignore: cast_nullable_to_non_nullable
                  as String?,
        installationDate: freezed == installationDate
            ? _value.installationDate
            : installationDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BaseStationImpl implements _BaseStation {
  const _$BaseStationImpl({
    required this.id,
    @JsonKey(name: 'site_id') required this.siteId,
    required this.name,
    required this.status,
    @JsonKey(name: 'region_id') this.regionId,
    this.latitude,
    this.longitude,
    @JsonKey(name: 'tower_type') this.towerType,
    this.operator,
    @JsonKey(name: 'installation_date') this.installationDate,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$BaseStationImpl.fromJson(Map<String, dynamic> json) =>
      _$$BaseStationImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'site_id')
  final String siteId;
  @override
  final String name;
  @override
  final String status;
  @override
  @JsonKey(name: 'region_id')
  final int? regionId;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  @JsonKey(name: 'tower_type')
  final String? towerType;
  @override
  final String? operator;
  @override
  @JsonKey(name: 'installation_date')
  final String? installationDate;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'BaseStation(id: $id, siteId: $siteId, name: $name, status: $status, regionId: $regionId, latitude: $latitude, longitude: $longitude, towerType: $towerType, operator: $operator, installationDate: $installationDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BaseStationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.siteId, siteId) || other.siteId == siteId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.regionId, regionId) ||
                other.regionId == regionId) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.towerType, towerType) ||
                other.towerType == towerType) &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            (identical(other.installationDate, installationDate) ||
                other.installationDate == installationDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    siteId,
    name,
    status,
    regionId,
    latitude,
    longitude,
    towerType,
    operator,
    installationDate,
    createdAt,
  );

  /// Create a copy of BaseStation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaseStationImplCopyWith<_$BaseStationImpl> get copyWith =>
      __$$BaseStationImplCopyWithImpl<_$BaseStationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BaseStationImplToJson(this);
  }
}

abstract class _BaseStation implements BaseStation {
  const factory _BaseStation({
    required final String id,
    @JsonKey(name: 'site_id') required final String siteId,
    required final String name,
    required final String status,
    @JsonKey(name: 'region_id') final int? regionId,
    final double? latitude,
    final double? longitude,
    @JsonKey(name: 'tower_type') final String? towerType,
    final String? operator,
    @JsonKey(name: 'installation_date') final String? installationDate,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$BaseStationImpl;

  factory _BaseStation.fromJson(Map<String, dynamic> json) =
      _$BaseStationImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'site_id')
  String get siteId;
  @override
  String get name;
  @override
  String get status;
  @override
  @JsonKey(name: 'region_id')
  int? get regionId;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  @JsonKey(name: 'tower_type')
  String? get towerType;
  @override
  String? get operator;
  @override
  @JsonKey(name: 'installation_date')
  String? get installationDate;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of BaseStation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaseStationImplCopyWith<_$BaseStationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
