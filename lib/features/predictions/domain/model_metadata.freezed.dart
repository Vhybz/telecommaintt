// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ModelMetadata _$ModelMetadataFromJson(Map<String, dynamic> json) {
  return _ModelMetadata.fromJson(json);
}

/// @nodoc
mixin _$ModelMetadata {
  @JsonKey(name: 'model_name')
  String get modelName => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  @JsonKey(name: 'trained_on')
  String get trainedOn => throw _privateConstructorUsedError;
  String get dataset => throw _privateConstructorUsedError;
  @JsonKey(name: 'n_samples_original')
  int get nSamplesOriginal => throw _privateConstructorUsedError;
  @JsonKey(name: 'n_samples_smote')
  int get nSamplesSmote => throw _privateConstructorUsedError;
  @JsonKey(name: 'n_features')
  int get nFeatures => throw _privateConstructorUsedError;
  List<String> get classes => throw _privateConstructorUsedError;
  @JsonKey(name: 'n_classes')
  int get nClasses => throw _privateConstructorUsedError;
  Map<String, dynamic> get hyperparameters =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get preprocessing => throw _privateConstructorUsedError;
  @JsonKey(name: 'cv_results')
  Map<String, dynamic> get cvResults => throw _privateConstructorUsedError;

  /// Serializes this ModelMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ModelMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModelMetadataCopyWith<ModelMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelMetadataCopyWith<$Res> {
  factory $ModelMetadataCopyWith(
    ModelMetadata value,
    $Res Function(ModelMetadata) then,
  ) = _$ModelMetadataCopyWithImpl<$Res, ModelMetadata>;
  @useResult
  $Res call({
    @JsonKey(name: 'model_name') String modelName,
    String version,
    @JsonKey(name: 'trained_on') String trainedOn,
    String dataset,
    @JsonKey(name: 'n_samples_original') int nSamplesOriginal,
    @JsonKey(name: 'n_samples_smote') int nSamplesSmote,
    @JsonKey(name: 'n_features') int nFeatures,
    List<String> classes,
    @JsonKey(name: 'n_classes') int nClasses,
    Map<String, dynamic> hyperparameters,
    Map<String, dynamic> preprocessing,
    @JsonKey(name: 'cv_results') Map<String, dynamic> cvResults,
  });
}

/// @nodoc
class _$ModelMetadataCopyWithImpl<$Res, $Val extends ModelMetadata>
    implements $ModelMetadataCopyWith<$Res> {
  _$ModelMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ModelMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modelName = null,
    Object? version = null,
    Object? trainedOn = null,
    Object? dataset = null,
    Object? nSamplesOriginal = null,
    Object? nSamplesSmote = null,
    Object? nFeatures = null,
    Object? classes = null,
    Object? nClasses = null,
    Object? hyperparameters = null,
    Object? preprocessing = null,
    Object? cvResults = null,
  }) {
    return _then(
      _value.copyWith(
            modelName: null == modelName
                ? _value.modelName
                : modelName // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            trainedOn: null == trainedOn
                ? _value.trainedOn
                : trainedOn // ignore: cast_nullable_to_non_nullable
                      as String,
            dataset: null == dataset
                ? _value.dataset
                : dataset // ignore: cast_nullable_to_non_nullable
                      as String,
            nSamplesOriginal: null == nSamplesOriginal
                ? _value.nSamplesOriginal
                : nSamplesOriginal // ignore: cast_nullable_to_non_nullable
                      as int,
            nSamplesSmote: null == nSamplesSmote
                ? _value.nSamplesSmote
                : nSamplesSmote // ignore: cast_nullable_to_non_nullable
                      as int,
            nFeatures: null == nFeatures
                ? _value.nFeatures
                : nFeatures // ignore: cast_nullable_to_non_nullable
                      as int,
            classes: null == classes
                ? _value.classes
                : classes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            nClasses: null == nClasses
                ? _value.nClasses
                : nClasses // ignore: cast_nullable_to_non_nullable
                      as int,
            hyperparameters: null == hyperparameters
                ? _value.hyperparameters
                : hyperparameters // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            preprocessing: null == preprocessing
                ? _value.preprocessing
                : preprocessing // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
            cvResults: null == cvResults
                ? _value.cvResults
                : cvResults // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ModelMetadataImplCopyWith<$Res>
    implements $ModelMetadataCopyWith<$Res> {
  factory _$$ModelMetadataImplCopyWith(
    _$ModelMetadataImpl value,
    $Res Function(_$ModelMetadataImpl) then,
  ) = __$$ModelMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'model_name') String modelName,
    String version,
    @JsonKey(name: 'trained_on') String trainedOn,
    String dataset,
    @JsonKey(name: 'n_samples_original') int nSamplesOriginal,
    @JsonKey(name: 'n_samples_smote') int nSamplesSmote,
    @JsonKey(name: 'n_features') int nFeatures,
    List<String> classes,
    @JsonKey(name: 'n_classes') int nClasses,
    Map<String, dynamic> hyperparameters,
    Map<String, dynamic> preprocessing,
    @JsonKey(name: 'cv_results') Map<String, dynamic> cvResults,
  });
}

/// @nodoc
class __$$ModelMetadataImplCopyWithImpl<$Res>
    extends _$ModelMetadataCopyWithImpl<$Res, _$ModelMetadataImpl>
    implements _$$ModelMetadataImplCopyWith<$Res> {
  __$$ModelMetadataImplCopyWithImpl(
    _$ModelMetadataImpl _value,
    $Res Function(_$ModelMetadataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ModelMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? modelName = null,
    Object? version = null,
    Object? trainedOn = null,
    Object? dataset = null,
    Object? nSamplesOriginal = null,
    Object? nSamplesSmote = null,
    Object? nFeatures = null,
    Object? classes = null,
    Object? nClasses = null,
    Object? hyperparameters = null,
    Object? preprocessing = null,
    Object? cvResults = null,
  }) {
    return _then(
      _$ModelMetadataImpl(
        modelName: null == modelName
            ? _value.modelName
            : modelName // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        trainedOn: null == trainedOn
            ? _value.trainedOn
            : trainedOn // ignore: cast_nullable_to_non_nullable
                  as String,
        dataset: null == dataset
            ? _value.dataset
            : dataset // ignore: cast_nullable_to_non_nullable
                  as String,
        nSamplesOriginal: null == nSamplesOriginal
            ? _value.nSamplesOriginal
            : nSamplesOriginal // ignore: cast_nullable_to_non_nullable
                  as int,
        nSamplesSmote: null == nSamplesSmote
            ? _value.nSamplesSmote
            : nSamplesSmote // ignore: cast_nullable_to_non_nullable
                  as int,
        nFeatures: null == nFeatures
            ? _value.nFeatures
            : nFeatures // ignore: cast_nullable_to_non_nullable
                  as int,
        classes: null == classes
            ? _value._classes
            : classes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        nClasses: null == nClasses
            ? _value.nClasses
            : nClasses // ignore: cast_nullable_to_non_nullable
                  as int,
        hyperparameters: null == hyperparameters
            ? _value._hyperparameters
            : hyperparameters // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        preprocessing: null == preprocessing
            ? _value._preprocessing
            : preprocessing // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
        cvResults: null == cvResults
            ? _value._cvResults
            : cvResults // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ModelMetadataImpl implements _ModelMetadata {
  const _$ModelMetadataImpl({
    @JsonKey(name: 'model_name') required this.modelName,
    required this.version,
    @JsonKey(name: 'trained_on') required this.trainedOn,
    required this.dataset,
    @JsonKey(name: 'n_samples_original') required this.nSamplesOriginal,
    @JsonKey(name: 'n_samples_smote') required this.nSamplesSmote,
    @JsonKey(name: 'n_features') required this.nFeatures,
    required final List<String> classes,
    @JsonKey(name: 'n_classes') required this.nClasses,
    required final Map<String, dynamic> hyperparameters,
    required final Map<String, dynamic> preprocessing,
    @JsonKey(name: 'cv_results') required final Map<String, dynamic> cvResults,
  }) : _classes = classes,
       _hyperparameters = hyperparameters,
       _preprocessing = preprocessing,
       _cvResults = cvResults;

  factory _$ModelMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModelMetadataImplFromJson(json);

  @override
  @JsonKey(name: 'model_name')
  final String modelName;
  @override
  final String version;
  @override
  @JsonKey(name: 'trained_on')
  final String trainedOn;
  @override
  final String dataset;
  @override
  @JsonKey(name: 'n_samples_original')
  final int nSamplesOriginal;
  @override
  @JsonKey(name: 'n_samples_smote')
  final int nSamplesSmote;
  @override
  @JsonKey(name: 'n_features')
  final int nFeatures;
  final List<String> _classes;
  @override
  List<String> get classes {
    if (_classes is EqualUnmodifiableListView) return _classes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_classes);
  }

  @override
  @JsonKey(name: 'n_classes')
  final int nClasses;
  final Map<String, dynamic> _hyperparameters;
  @override
  Map<String, dynamic> get hyperparameters {
    if (_hyperparameters is EqualUnmodifiableMapView) return _hyperparameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_hyperparameters);
  }

  final Map<String, dynamic> _preprocessing;
  @override
  Map<String, dynamic> get preprocessing {
    if (_preprocessing is EqualUnmodifiableMapView) return _preprocessing;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_preprocessing);
  }

  final Map<String, dynamic> _cvResults;
  @override
  @JsonKey(name: 'cv_results')
  Map<String, dynamic> get cvResults {
    if (_cvResults is EqualUnmodifiableMapView) return _cvResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_cvResults);
  }

  @override
  String toString() {
    return 'ModelMetadata(modelName: $modelName, version: $version, trainedOn: $trainedOn, dataset: $dataset, nSamplesOriginal: $nSamplesOriginal, nSamplesSmote: $nSamplesSmote, nFeatures: $nFeatures, classes: $classes, nClasses: $nClasses, hyperparameters: $hyperparameters, preprocessing: $preprocessing, cvResults: $cvResults)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModelMetadataImpl &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.trainedOn, trainedOn) ||
                other.trainedOn == trainedOn) &&
            (identical(other.dataset, dataset) || other.dataset == dataset) &&
            (identical(other.nSamplesOriginal, nSamplesOriginal) ||
                other.nSamplesOriginal == nSamplesOriginal) &&
            (identical(other.nSamplesSmote, nSamplesSmote) ||
                other.nSamplesSmote == nSamplesSmote) &&
            (identical(other.nFeatures, nFeatures) ||
                other.nFeatures == nFeatures) &&
            const DeepCollectionEquality().equals(other._classes, _classes) &&
            (identical(other.nClasses, nClasses) ||
                other.nClasses == nClasses) &&
            const DeepCollectionEquality().equals(
              other._hyperparameters,
              _hyperparameters,
            ) &&
            const DeepCollectionEquality().equals(
              other._preprocessing,
              _preprocessing,
            ) &&
            const DeepCollectionEquality().equals(
              other._cvResults,
              _cvResults,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    modelName,
    version,
    trainedOn,
    dataset,
    nSamplesOriginal,
    nSamplesSmote,
    nFeatures,
    const DeepCollectionEquality().hash(_classes),
    nClasses,
    const DeepCollectionEquality().hash(_hyperparameters),
    const DeepCollectionEquality().hash(_preprocessing),
    const DeepCollectionEquality().hash(_cvResults),
  );

  /// Create a copy of ModelMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModelMetadataImplCopyWith<_$ModelMetadataImpl> get copyWith =>
      __$$ModelMetadataImplCopyWithImpl<_$ModelMetadataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModelMetadataImplToJson(this);
  }
}

abstract class _ModelMetadata implements ModelMetadata {
  const factory _ModelMetadata({
    @JsonKey(name: 'model_name') required final String modelName,
    required final String version,
    @JsonKey(name: 'trained_on') required final String trainedOn,
    required final String dataset,
    @JsonKey(name: 'n_samples_original') required final int nSamplesOriginal,
    @JsonKey(name: 'n_samples_smote') required final int nSamplesSmote,
    @JsonKey(name: 'n_features') required final int nFeatures,
    required final List<String> classes,
    @JsonKey(name: 'n_classes') required final int nClasses,
    required final Map<String, dynamic> hyperparameters,
    required final Map<String, dynamic> preprocessing,
    @JsonKey(name: 'cv_results') required final Map<String, dynamic> cvResults,
  }) = _$ModelMetadataImpl;

  factory _ModelMetadata.fromJson(Map<String, dynamic> json) =
      _$ModelMetadataImpl.fromJson;

  @override
  @JsonKey(name: 'model_name')
  String get modelName;
  @override
  String get version;
  @override
  @JsonKey(name: 'trained_on')
  String get trainedOn;
  @override
  String get dataset;
  @override
  @JsonKey(name: 'n_samples_original')
  int get nSamplesOriginal;
  @override
  @JsonKey(name: 'n_samples_smote')
  int get nSamplesSmote;
  @override
  @JsonKey(name: 'n_features')
  int get nFeatures;
  @override
  List<String> get classes;
  @override
  @JsonKey(name: 'n_classes')
  int get nClasses;
  @override
  Map<String, dynamic> get hyperparameters;
  @override
  Map<String, dynamic> get preprocessing;
  @override
  @JsonKey(name: 'cv_results')
  Map<String, dynamic> get cvResults;

  /// Create a copy of ModelMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModelMetadataImplCopyWith<_$ModelMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
