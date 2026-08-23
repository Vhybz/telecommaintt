// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'kpi_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

KpiRecord _$KpiRecordFromJson(Map<String, dynamic> json) {
  return _KpiRecord.fromJson(json);
}

/// @nodoc
mixin _$KpiRecord {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'station_id')
  String get stationId => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;
  double? get availability => throw _privateConstructorUsedError;
  double? get cssr => throw _privateConstructorUsedError;
  double? get cdr => throw _privateConstructorUsedError;
  double? get rsrp => throw _privateConstructorUsedError;
  double? get rsrq => throw _privateConstructorUsedError;
  double? get sinr => throw _privateConstructorUsedError;
  double? get temperature => throw _privateConstructorUsedError;
  double? get voltage => throw _privateConstructorUsedError;
  @JsonKey(name: 'power_consumption')
  double? get powerConsumption => throw _privateConstructorUsedError;

  /// Serializes this KpiRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of KpiRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $KpiRecordCopyWith<KpiRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $KpiRecordCopyWith<$Res> {
  factory $KpiRecordCopyWith(KpiRecord value, $Res Function(KpiRecord) then) =
      _$KpiRecordCopyWithImpl<$Res, KpiRecord>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'station_id') String stationId,
    String timestamp,
    double? availability,
    double? cssr,
    double? cdr,
    double? rsrp,
    double? rsrq,
    double? sinr,
    double? temperature,
    double? voltage,
    @JsonKey(name: 'power_consumption') double? powerConsumption,
  });
}

/// @nodoc
class _$KpiRecordCopyWithImpl<$Res, $Val extends KpiRecord>
    implements $KpiRecordCopyWith<$Res> {
  _$KpiRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of KpiRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stationId = null,
    Object? timestamp = null,
    Object? availability = freezed,
    Object? cssr = freezed,
    Object? cdr = freezed,
    Object? rsrp = freezed,
    Object? rsrq = freezed,
    Object? sinr = freezed,
    Object? temperature = freezed,
    Object? voltage = freezed,
    Object? powerConsumption = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            stationId: null == stationId
                ? _value.stationId
                : stationId // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as String,
            availability: freezed == availability
                ? _value.availability
                : availability // ignore: cast_nullable_to_non_nullable
                      as double?,
            cssr: freezed == cssr
                ? _value.cssr
                : cssr // ignore: cast_nullable_to_non_nullable
                      as double?,
            cdr: freezed == cdr
                ? _value.cdr
                : cdr // ignore: cast_nullable_to_non_nullable
                      as double?,
            rsrp: freezed == rsrp
                ? _value.rsrp
                : rsrp // ignore: cast_nullable_to_non_nullable
                      as double?,
            rsrq: freezed == rsrq
                ? _value.rsrq
                : rsrq // ignore: cast_nullable_to_non_nullable
                      as double?,
            sinr: freezed == sinr
                ? _value.sinr
                : sinr // ignore: cast_nullable_to_non_nullable
                      as double?,
            temperature: freezed == temperature
                ? _value.temperature
                : temperature // ignore: cast_nullable_to_non_nullable
                      as double?,
            voltage: freezed == voltage
                ? _value.voltage
                : voltage // ignore: cast_nullable_to_non_nullable
                      as double?,
            powerConsumption: freezed == powerConsumption
                ? _value.powerConsumption
                : powerConsumption // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$KpiRecordImplCopyWith<$Res>
    implements $KpiRecordCopyWith<$Res> {
  factory _$$KpiRecordImplCopyWith(
    _$KpiRecordImpl value,
    $Res Function(_$KpiRecordImpl) then,
  ) = __$$KpiRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'station_id') String stationId,
    String timestamp,
    double? availability,
    double? cssr,
    double? cdr,
    double? rsrp,
    double? rsrq,
    double? sinr,
    double? temperature,
    double? voltage,
    @JsonKey(name: 'power_consumption') double? powerConsumption,
  });
}

/// @nodoc
class __$$KpiRecordImplCopyWithImpl<$Res>
    extends _$KpiRecordCopyWithImpl<$Res, _$KpiRecordImpl>
    implements _$$KpiRecordImplCopyWith<$Res> {
  __$$KpiRecordImplCopyWithImpl(
    _$KpiRecordImpl _value,
    $Res Function(_$KpiRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of KpiRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stationId = null,
    Object? timestamp = null,
    Object? availability = freezed,
    Object? cssr = freezed,
    Object? cdr = freezed,
    Object? rsrp = freezed,
    Object? rsrq = freezed,
    Object? sinr = freezed,
    Object? temperature = freezed,
    Object? voltage = freezed,
    Object? powerConsumption = freezed,
  }) {
    return _then(
      _$KpiRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        stationId: null == stationId
            ? _value.stationId
            : stationId // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as String,
        availability: freezed == availability
            ? _value.availability
            : availability // ignore: cast_nullable_to_non_nullable
                  as double?,
        cssr: freezed == cssr
            ? _value.cssr
            : cssr // ignore: cast_nullable_to_non_nullable
                  as double?,
        cdr: freezed == cdr
            ? _value.cdr
            : cdr // ignore: cast_nullable_to_non_nullable
                  as double?,
        rsrp: freezed == rsrp
            ? _value.rsrp
            : rsrp // ignore: cast_nullable_to_non_nullable
                  as double?,
        rsrq: freezed == rsrq
            ? _value.rsrq
            : rsrq // ignore: cast_nullable_to_non_nullable
                  as double?,
        sinr: freezed == sinr
            ? _value.sinr
            : sinr // ignore: cast_nullable_to_non_nullable
                  as double?,
        temperature: freezed == temperature
            ? _value.temperature
            : temperature // ignore: cast_nullable_to_non_nullable
                  as double?,
        voltage: freezed == voltage
            ? _value.voltage
            : voltage // ignore: cast_nullable_to_non_nullable
                  as double?,
        powerConsumption: freezed == powerConsumption
            ? _value.powerConsumption
            : powerConsumption // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$KpiRecordImpl implements _KpiRecord {
  const _$KpiRecordImpl({
    required this.id,
    @JsonKey(name: 'station_id') required this.stationId,
    required this.timestamp,
    this.availability,
    this.cssr,
    this.cdr,
    this.rsrp,
    this.rsrq,
    this.sinr,
    this.temperature,
    this.voltage,
    @JsonKey(name: 'power_consumption') this.powerConsumption,
  });

  factory _$KpiRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$KpiRecordImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'station_id')
  final String stationId;
  @override
  final String timestamp;
  @override
  final double? availability;
  @override
  final double? cssr;
  @override
  final double? cdr;
  @override
  final double? rsrp;
  @override
  final double? rsrq;
  @override
  final double? sinr;
  @override
  final double? temperature;
  @override
  final double? voltage;
  @override
  @JsonKey(name: 'power_consumption')
  final double? powerConsumption;

  @override
  String toString() {
    return 'KpiRecord(id: $id, stationId: $stationId, timestamp: $timestamp, availability: $availability, cssr: $cssr, cdr: $cdr, rsrp: $rsrp, rsrq: $rsrq, sinr: $sinr, temperature: $temperature, voltage: $voltage, powerConsumption: $powerConsumption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KpiRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.cssr, cssr) || other.cssr == cssr) &&
            (identical(other.cdr, cdr) || other.cdr == cdr) &&
            (identical(other.rsrp, rsrp) || other.rsrp == rsrp) &&
            (identical(other.rsrq, rsrq) || other.rsrq == rsrq) &&
            (identical(other.sinr, sinr) || other.sinr == sinr) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.voltage, voltage) || other.voltage == voltage) &&
            (identical(other.powerConsumption, powerConsumption) ||
                other.powerConsumption == powerConsumption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    stationId,
    timestamp,
    availability,
    cssr,
    cdr,
    rsrp,
    rsrq,
    sinr,
    temperature,
    voltage,
    powerConsumption,
  );

  /// Create a copy of KpiRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$KpiRecordImplCopyWith<_$KpiRecordImpl> get copyWith =>
      __$$KpiRecordImplCopyWithImpl<_$KpiRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$KpiRecordImplToJson(this);
  }
}

abstract class _KpiRecord implements KpiRecord {
  const factory _KpiRecord({
    required final String id,
    @JsonKey(name: 'station_id') required final String stationId,
    required final String timestamp,
    final double? availability,
    final double? cssr,
    final double? cdr,
    final double? rsrp,
    final double? rsrq,
    final double? sinr,
    final double? temperature,
    final double? voltage,
    @JsonKey(name: 'power_consumption') final double? powerConsumption,
  }) = _$KpiRecordImpl;

  factory _KpiRecord.fromJson(Map<String, dynamic> json) =
      _$KpiRecordImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'station_id')
  String get stationId;
  @override
  String get timestamp;
  @override
  double? get availability;
  @override
  double? get cssr;
  @override
  double? get cdr;
  @override
  double? get rsrp;
  @override
  double? get rsrq;
  @override
  double? get sinr;
  @override
  double? get temperature;
  @override
  double? get voltage;
  @override
  @JsonKey(name: 'power_consumption')
  double? get powerConsumption;

  /// Create a copy of KpiRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$KpiRecordImplCopyWith<_$KpiRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
