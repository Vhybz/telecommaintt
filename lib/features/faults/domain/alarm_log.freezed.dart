// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alarm_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AlarmLog _$AlarmLogFromJson(Map<String, dynamic> json) {
  return _AlarmLog.fromJson(json);
}

/// @nodoc
mixin _$AlarmLog {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'station_id')
  String? get stationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'equipment_id')
  String? get equipmentId => throw _privateConstructorUsedError;
  String? get severity => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'resolved_at')
  String? get resolvedAt => throw _privateConstructorUsedError;

  /// Serializes this AlarmLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlarmLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlarmLogCopyWith<AlarmLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlarmLogCopyWith<$Res> {
  factory $AlarmLogCopyWith(AlarmLog value, $Res Function(AlarmLog) then) =
      _$AlarmLogCopyWithImpl<$Res, AlarmLog>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'station_id') String? stationId,
    @JsonKey(name: 'equipment_id') String? equipmentId,
    String? severity,
    String? description,
    String? status,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'resolved_at') String? resolvedAt,
  });
}

/// @nodoc
class _$AlarmLogCopyWithImpl<$Res, $Val extends AlarmLog>
    implements $AlarmLogCopyWith<$Res> {
  _$AlarmLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlarmLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stationId = freezed,
    Object? equipmentId = freezed,
    Object? severity = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            stationId: freezed == stationId
                ? _value.stationId
                : stationId // ignore: cast_nullable_to_non_nullable
                      as String?,
            equipmentId: freezed == equipmentId
                ? _value.equipmentId
                : equipmentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            severity: freezed == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            resolvedAt: freezed == resolvedAt
                ? _value.resolvedAt
                : resolvedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlarmLogImplCopyWith<$Res>
    implements $AlarmLogCopyWith<$Res> {
  factory _$$AlarmLogImplCopyWith(
    _$AlarmLogImpl value,
    $Res Function(_$AlarmLogImpl) then,
  ) = __$$AlarmLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'station_id') String? stationId,
    @JsonKey(name: 'equipment_id') String? equipmentId,
    String? severity,
    String? description,
    String? status,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'resolved_at') String? resolvedAt,
  });
}

/// @nodoc
class __$$AlarmLogImplCopyWithImpl<$Res>
    extends _$AlarmLogCopyWithImpl<$Res, _$AlarmLogImpl>
    implements _$$AlarmLogImplCopyWith<$Res> {
  __$$AlarmLogImplCopyWithImpl(
    _$AlarmLogImpl _value,
    $Res Function(_$AlarmLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AlarmLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stationId = freezed,
    Object? equipmentId = freezed,
    Object? severity = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? createdAt = freezed,
    Object? resolvedAt = freezed,
  }) {
    return _then(
      _$AlarmLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        stationId: freezed == stationId
            ? _value.stationId
            : stationId // ignore: cast_nullable_to_non_nullable
                  as String?,
        equipmentId: freezed == equipmentId
            ? _value.equipmentId
            : equipmentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        severity: freezed == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlarmLogImpl implements _AlarmLog {
  const _$AlarmLogImpl({
    required this.id,
    @JsonKey(name: 'station_id') this.stationId,
    @JsonKey(name: 'equipment_id') this.equipmentId,
    this.severity,
    this.description,
    this.status,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'resolved_at') this.resolvedAt,
  });

  factory _$AlarmLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlarmLogImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'station_id')
  final String? stationId;
  @override
  @JsonKey(name: 'equipment_id')
  final String? equipmentId;
  @override
  final String? severity;
  @override
  final String? description;
  @override
  final String? status;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'resolved_at')
  final String? resolvedAt;

  @override
  String toString() {
    return 'AlarmLog(id: $id, stationId: $stationId, equipmentId: $equipmentId, severity: $severity, description: $description, status: $status, createdAt: $createdAt, resolvedAt: $resolvedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlarmLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.equipmentId, equipmentId) ||
                other.equipmentId == equipmentId) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    stationId,
    equipmentId,
    severity,
    description,
    status,
    createdAt,
    resolvedAt,
  );

  /// Create a copy of AlarmLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlarmLogImplCopyWith<_$AlarmLogImpl> get copyWith =>
      __$$AlarmLogImplCopyWithImpl<_$AlarmLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlarmLogImplToJson(this);
  }
}

abstract class _AlarmLog implements AlarmLog {
  const factory _AlarmLog({
    required final String id,
    @JsonKey(name: 'station_id') final String? stationId,
    @JsonKey(name: 'equipment_id') final String? equipmentId,
    final String? severity,
    final String? description,
    final String? status,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'resolved_at') final String? resolvedAt,
  }) = _$AlarmLogImpl;

  factory _AlarmLog.fromJson(Map<String, dynamic> json) =
      _$AlarmLogImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'station_id')
  String? get stationId;
  @override
  @JsonKey(name: 'equipment_id')
  String? get equipmentId;
  @override
  String? get severity;
  @override
  String? get description;
  @override
  String? get status;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'resolved_at')
  String? get resolvedAt;

  /// Create a copy of AlarmLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlarmLogImplCopyWith<_$AlarmLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
