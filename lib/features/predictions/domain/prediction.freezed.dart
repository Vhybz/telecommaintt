// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prediction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Prediction _$PredictionFromJson(Map<String, dynamic> json) {
  return _Prediction.fromJson(json);
}

/// @nodoc
mixin _$Prediction {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'station_id')
  String? get stationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'equipment_id')
  String? get equipmentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fault_type')
  String? get faultType => throw _privateConstructorUsedError;
  double get probability => throw _privateConstructorUsedError;
  @JsonKey(name: 'risk_level')
  String? get riskLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'recommended_action')
  String? get recommendedAction => throw _privateConstructorUsedError;
  @JsonKey(name: 'dcr_cssr_ratio')
  double? get dcrCssrRatio => throw _privateConstructorUsedError;
  @JsonKey(name: 'tp_prb_efficiency')
  double? get tpPrbEfficiency => throw _privateConstructorUsedError;
  @JsonKey(name: 'avail_x_cssr')
  double? get availXCssr => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Prediction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Prediction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PredictionCopyWith<Prediction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictionCopyWith<$Res> {
  factory $PredictionCopyWith(
    Prediction value,
    $Res Function(Prediction) then,
  ) = _$PredictionCopyWithImpl<$Res, Prediction>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'station_id') String? stationId,
    @JsonKey(name: 'equipment_id') String? equipmentId,
    @JsonKey(name: 'fault_type') String? faultType,
    double probability,
    @JsonKey(name: 'risk_level') String? riskLevel,
    @JsonKey(name: 'recommended_action') String? recommendedAction,
    @JsonKey(name: 'dcr_cssr_ratio') double? dcrCssrRatio,
    @JsonKey(name: 'tp_prb_efficiency') double? tpPrbEfficiency,
    @JsonKey(name: 'avail_x_cssr') double? availXCssr,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class _$PredictionCopyWithImpl<$Res, $Val extends Prediction>
    implements $PredictionCopyWith<$Res> {
  _$PredictionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Prediction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stationId = freezed,
    Object? equipmentId = freezed,
    Object? faultType = freezed,
    Object? probability = null,
    Object? riskLevel = freezed,
    Object? recommendedAction = freezed,
    Object? dcrCssrRatio = freezed,
    Object? tpPrbEfficiency = freezed,
    Object? availXCssr = freezed,
    Object? createdAt = freezed,
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
            faultType: freezed == faultType
                ? _value.faultType
                : faultType // ignore: cast_nullable_to_non_nullable
                      as String?,
            probability: null == probability
                ? _value.probability
                : probability // ignore: cast_nullable_to_non_nullable
                      as double,
            riskLevel: freezed == riskLevel
                ? _value.riskLevel
                : riskLevel // ignore: cast_nullable_to_non_nullable
                      as String?,
            recommendedAction: freezed == recommendedAction
                ? _value.recommendedAction
                : recommendedAction // ignore: cast_nullable_to_non_nullable
                      as String?,
            dcrCssrRatio: freezed == dcrCssrRatio
                ? _value.dcrCssrRatio
                : dcrCssrRatio // ignore: cast_nullable_to_non_nullable
                      as double?,
            tpPrbEfficiency: freezed == tpPrbEfficiency
                ? _value.tpPrbEfficiency
                : tpPrbEfficiency // ignore: cast_nullable_to_non_nullable
                      as double?,
            availXCssr: freezed == availXCssr
                ? _value.availXCssr
                : availXCssr // ignore: cast_nullable_to_non_nullable
                      as double?,
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
abstract class _$$PredictionImplCopyWith<$Res>
    implements $PredictionCopyWith<$Res> {
  factory _$$PredictionImplCopyWith(
    _$PredictionImpl value,
    $Res Function(_$PredictionImpl) then,
  ) = __$$PredictionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'station_id') String? stationId,
    @JsonKey(name: 'equipment_id') String? equipmentId,
    @JsonKey(name: 'fault_type') String? faultType,
    double probability,
    @JsonKey(name: 'risk_level') String? riskLevel,
    @JsonKey(name: 'recommended_action') String? recommendedAction,
    @JsonKey(name: 'dcr_cssr_ratio') double? dcrCssrRatio,
    @JsonKey(name: 'tp_prb_efficiency') double? tpPrbEfficiency,
    @JsonKey(name: 'avail_x_cssr') double? availXCssr,
    @JsonKey(name: 'created_at') String? createdAt,
  });
}

/// @nodoc
class __$$PredictionImplCopyWithImpl<$Res>
    extends _$PredictionCopyWithImpl<$Res, _$PredictionImpl>
    implements _$$PredictionImplCopyWith<$Res> {
  __$$PredictionImplCopyWithImpl(
    _$PredictionImpl _value,
    $Res Function(_$PredictionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Prediction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? stationId = freezed,
    Object? equipmentId = freezed,
    Object? faultType = freezed,
    Object? probability = null,
    Object? riskLevel = freezed,
    Object? recommendedAction = freezed,
    Object? dcrCssrRatio = freezed,
    Object? tpPrbEfficiency = freezed,
    Object? availXCssr = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$PredictionImpl(
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
        faultType: freezed == faultType
            ? _value.faultType
            : faultType // ignore: cast_nullable_to_non_nullable
                  as String?,
        probability: null == probability
            ? _value.probability
            : probability // ignore: cast_nullable_to_non_nullable
                  as double,
        riskLevel: freezed == riskLevel
            ? _value.riskLevel
            : riskLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        recommendedAction: freezed == recommendedAction
            ? _value.recommendedAction
            : recommendedAction // ignore: cast_nullable_to_non_nullable
                  as String?,
        dcrCssrRatio: freezed == dcrCssrRatio
            ? _value.dcrCssrRatio
            : dcrCssrRatio // ignore: cast_nullable_to_non_nullable
                  as double?,
        tpPrbEfficiency: freezed == tpPrbEfficiency
            ? _value.tpPrbEfficiency
            : tpPrbEfficiency // ignore: cast_nullable_to_non_nullable
                  as double?,
        availXCssr: freezed == availXCssr
            ? _value.availXCssr
            : availXCssr // ignore: cast_nullable_to_non_nullable
                  as double?,
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
class _$PredictionImpl implements _Prediction {
  const _$PredictionImpl({
    required this.id,
    @JsonKey(name: 'station_id') this.stationId,
    @JsonKey(name: 'equipment_id') this.equipmentId,
    @JsonKey(name: 'fault_type') this.faultType,
    this.probability = 0.0,
    @JsonKey(name: 'risk_level') this.riskLevel,
    @JsonKey(name: 'recommended_action') this.recommendedAction,
    @JsonKey(name: 'dcr_cssr_ratio') this.dcrCssrRatio,
    @JsonKey(name: 'tp_prb_efficiency') this.tpPrbEfficiency,
    @JsonKey(name: 'avail_x_cssr') this.availXCssr,
    @JsonKey(name: 'created_at') this.createdAt,
  });

  factory _$PredictionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'station_id')
  final String? stationId;
  @override
  @JsonKey(name: 'equipment_id')
  final String? equipmentId;
  @override
  @JsonKey(name: 'fault_type')
  final String? faultType;
  @override
  @JsonKey()
  final double probability;
  @override
  @JsonKey(name: 'risk_level')
  final String? riskLevel;
  @override
  @JsonKey(name: 'recommended_action')
  final String? recommendedAction;
  @override
  @JsonKey(name: 'dcr_cssr_ratio')
  final double? dcrCssrRatio;
  @override
  @JsonKey(name: 'tp_prb_efficiency')
  final double? tpPrbEfficiency;
  @override
  @JsonKey(name: 'avail_x_cssr')
  final double? availXCssr;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @override
  String toString() {
    return 'Prediction(id: $id, stationId: $stationId, equipmentId: $equipmentId, faultType: $faultType, probability: $probability, riskLevel: $riskLevel, recommendedAction: $recommendedAction, dcrCssrRatio: $dcrCssrRatio, tpPrbEfficiency: $tpPrbEfficiency, availXCssr: $availXCssr, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.equipmentId, equipmentId) ||
                other.equipmentId == equipmentId) &&
            (identical(other.faultType, faultType) ||
                other.faultType == faultType) &&
            (identical(other.probability, probability) ||
                other.probability == probability) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.recommendedAction, recommendedAction) ||
                other.recommendedAction == recommendedAction) &&
            (identical(other.dcrCssrRatio, dcrCssrRatio) ||
                other.dcrCssrRatio == dcrCssrRatio) &&
            (identical(other.tpPrbEfficiency, tpPrbEfficiency) ||
                other.tpPrbEfficiency == tpPrbEfficiency) &&
            (identical(other.availXCssr, availXCssr) ||
                other.availXCssr == availXCssr) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    stationId,
    equipmentId,
    faultType,
    probability,
    riskLevel,
    recommendedAction,
    dcrCssrRatio,
    tpPrbEfficiency,
    availXCssr,
    createdAt,
  );

  /// Create a copy of Prediction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictionImplCopyWith<_$PredictionImpl> get copyWith =>
      __$$PredictionImplCopyWithImpl<_$PredictionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictionImplToJson(this);
  }
}

abstract class _Prediction implements Prediction {
  const factory _Prediction({
    required final String id,
    @JsonKey(name: 'station_id') final String? stationId,
    @JsonKey(name: 'equipment_id') final String? equipmentId,
    @JsonKey(name: 'fault_type') final String? faultType,
    final double probability,
    @JsonKey(name: 'risk_level') final String? riskLevel,
    @JsonKey(name: 'recommended_action') final String? recommendedAction,
    @JsonKey(name: 'dcr_cssr_ratio') final double? dcrCssrRatio,
    @JsonKey(name: 'tp_prb_efficiency') final double? tpPrbEfficiency,
    @JsonKey(name: 'avail_x_cssr') final double? availXCssr,
    @JsonKey(name: 'created_at') final String? createdAt,
  }) = _$PredictionImpl;

  factory _Prediction.fromJson(Map<String, dynamic> json) =
      _$PredictionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'station_id')
  String? get stationId;
  @override
  @JsonKey(name: 'equipment_id')
  String? get equipmentId;
  @override
  @JsonKey(name: 'fault_type')
  String? get faultType;
  @override
  double get probability;
  @override
  @JsonKey(name: 'risk_level')
  String? get riskLevel;
  @override
  @JsonKey(name: 'recommended_action')
  String? get recommendedAction;
  @override
  @JsonKey(name: 'dcr_cssr_ratio')
  double? get dcrCssrRatio;
  @override
  @JsonKey(name: 'tp_prb_efficiency')
  double? get tpPrbEfficiency;
  @override
  @JsonKey(name: 'avail_x_cssr')
  double? get availXCssr;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;

  /// Create a copy of Prediction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PredictionImplCopyWith<_$PredictionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
