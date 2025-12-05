// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'earthquake.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EarthquakeResponse _$EarthquakeResponseFromJson(Map<String, dynamic> json) {
  return _EarthquakeResponse.fromJson(json);
}

/// @nodoc
mixin _$EarthquakeResponse {
  String get type => throw _privateConstructorUsedError;
  EarthquakeMetadata get metadata => throw _privateConstructorUsedError;
  List<EarthquakeFeature> get features => throw _privateConstructorUsedError;
  List<double>? get bbox => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EarthquakeResponseCopyWith<EarthquakeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EarthquakeResponseCopyWith<$Res> {
  factory $EarthquakeResponseCopyWith(
          EarthquakeResponse value, $Res Function(EarthquakeResponse) then) =
      _$EarthquakeResponseCopyWithImpl<$Res, EarthquakeResponse>;
  @useResult
  $Res call(
      {String type,
      EarthquakeMetadata metadata,
      List<EarthquakeFeature> features,
      List<double>? bbox});

  $EarthquakeMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class _$EarthquakeResponseCopyWithImpl<$Res, $Val extends EarthquakeResponse>
    implements $EarthquakeResponseCopyWith<$Res> {
  _$EarthquakeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? metadata = null,
    Object? features = null,
    Object? bbox = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as EarthquakeMetadata,
      features: null == features
          ? _value.features
          : features // ignore: cast_nullable_to_non_nullable
              as List<EarthquakeFeature>,
      bbox: freezed == bbox
          ? _value.bbox
          : bbox // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EarthquakeMetadataCopyWith<$Res> get metadata {
    return $EarthquakeMetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EarthquakeResponseImplCopyWith<$Res>
    implements $EarthquakeResponseCopyWith<$Res> {
  factory _$$EarthquakeResponseImplCopyWith(_$EarthquakeResponseImpl value,
          $Res Function(_$EarthquakeResponseImpl) then) =
      __$$EarthquakeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      EarthquakeMetadata metadata,
      List<EarthquakeFeature> features,
      List<double>? bbox});

  @override
  $EarthquakeMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$EarthquakeResponseImplCopyWithImpl<$Res>
    extends _$EarthquakeResponseCopyWithImpl<$Res, _$EarthquakeResponseImpl>
    implements _$$EarthquakeResponseImplCopyWith<$Res> {
  __$$EarthquakeResponseImplCopyWithImpl(_$EarthquakeResponseImpl _value,
      $Res Function(_$EarthquakeResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? metadata = null,
    Object? features = null,
    Object? bbox = freezed,
  }) {
    return _then(_$EarthquakeResponseImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as EarthquakeMetadata,
      features: null == features
          ? _value._features
          : features // ignore: cast_nullable_to_non_nullable
              as List<EarthquakeFeature>,
      bbox: freezed == bbox
          ? _value._bbox
          : bbox // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EarthquakeResponseImpl implements _EarthquakeResponse {
  const _$EarthquakeResponseImpl(
      {required this.type,
      required this.metadata,
      required final List<EarthquakeFeature> features,
      final List<double>? bbox})
      : _features = features,
        _bbox = bbox;

  factory _$EarthquakeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$EarthquakeResponseImplFromJson(json);

  @override
  final String type;
  @override
  final EarthquakeMetadata metadata;
  final List<EarthquakeFeature> _features;
  @override
  List<EarthquakeFeature> get features {
    if (_features is EqualUnmodifiableListView) return _features;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_features);
  }

  final List<double>? _bbox;
  @override
  List<double>? get bbox {
    final value = _bbox;
    if (value == null) return null;
    if (_bbox is EqualUnmodifiableListView) return _bbox;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'EarthquakeResponse(type: $type, metadata: $metadata, features: $features, bbox: $bbox)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EarthquakeResponseImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata) &&
            const DeepCollectionEquality().equals(other._features, _features) &&
            const DeepCollectionEquality().equals(other._bbox, _bbox));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      metadata,
      const DeepCollectionEquality().hash(_features),
      const DeepCollectionEquality().hash(_bbox));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EarthquakeResponseImplCopyWith<_$EarthquakeResponseImpl> get copyWith =>
      __$$EarthquakeResponseImplCopyWithImpl<_$EarthquakeResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EarthquakeResponseImplToJson(
      this,
    );
  }
}

abstract class _EarthquakeResponse implements EarthquakeResponse {
  const factory _EarthquakeResponse(
      {required final String type,
      required final EarthquakeMetadata metadata,
      required final List<EarthquakeFeature> features,
      final List<double>? bbox}) = _$EarthquakeResponseImpl;

  factory _EarthquakeResponse.fromJson(Map<String, dynamic> json) =
      _$EarthquakeResponseImpl.fromJson;

  @override
  String get type;
  @override
  EarthquakeMetadata get metadata;
  @override
  List<EarthquakeFeature> get features;
  @override
  List<double>? get bbox;
  @override
  @JsonKey(ignore: true)
  _$$EarthquakeResponseImplCopyWith<_$EarthquakeResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EarthquakeMetadata _$EarthquakeMetadataFromJson(Map<String, dynamic> json) {
  return _EarthquakeMetadata.fromJson(json);
}

/// @nodoc
mixin _$EarthquakeMetadata {
  int get generated => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  String get api => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EarthquakeMetadataCopyWith<EarthquakeMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EarthquakeMetadataCopyWith<$Res> {
  factory $EarthquakeMetadataCopyWith(
          EarthquakeMetadata value, $Res Function(EarthquakeMetadata) then) =
      _$EarthquakeMetadataCopyWithImpl<$Res, EarthquakeMetadata>;
  @useResult
  $Res call(
      {int generated,
      String url,
      String title,
      int status,
      String api,
      int count});
}

/// @nodoc
class _$EarthquakeMetadataCopyWithImpl<$Res, $Val extends EarthquakeMetadata>
    implements $EarthquakeMetadataCopyWith<$Res> {
  _$EarthquakeMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? generated = null,
    Object? url = null,
    Object? title = null,
    Object? status = null,
    Object? api = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      generated: null == generated
          ? _value.generated
          : generated // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      api: null == api
          ? _value.api
          : api // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EarthquakeMetadataImplCopyWith<$Res>
    implements $EarthquakeMetadataCopyWith<$Res> {
  factory _$$EarthquakeMetadataImplCopyWith(_$EarthquakeMetadataImpl value,
          $Res Function(_$EarthquakeMetadataImpl) then) =
      __$$EarthquakeMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int generated,
      String url,
      String title,
      int status,
      String api,
      int count});
}

/// @nodoc
class __$$EarthquakeMetadataImplCopyWithImpl<$Res>
    extends _$EarthquakeMetadataCopyWithImpl<$Res, _$EarthquakeMetadataImpl>
    implements _$$EarthquakeMetadataImplCopyWith<$Res> {
  __$$EarthquakeMetadataImplCopyWithImpl(_$EarthquakeMetadataImpl _value,
      $Res Function(_$EarthquakeMetadataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? generated = null,
    Object? url = null,
    Object? title = null,
    Object? status = null,
    Object? api = null,
    Object? count = null,
  }) {
    return _then(_$EarthquakeMetadataImpl(
      generated: null == generated
          ? _value.generated
          : generated // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      api: null == api
          ? _value.api
          : api // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EarthquakeMetadataImpl implements _EarthquakeMetadata {
  const _$EarthquakeMetadataImpl(
      {required this.generated,
      required this.url,
      required this.title,
      required this.status,
      required this.api,
      required this.count});

  factory _$EarthquakeMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$EarthquakeMetadataImplFromJson(json);

  @override
  final int generated;
  @override
  final String url;
  @override
  final String title;
  @override
  final int status;
  @override
  final String api;
  @override
  final int count;

  @override
  String toString() {
    return 'EarthquakeMetadata(generated: $generated, url: $url, title: $title, status: $status, api: $api, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EarthquakeMetadataImpl &&
            (identical(other.generated, generated) ||
                other.generated == generated) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.api, api) || other.api == api) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, generated, url, title, status, api, count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EarthquakeMetadataImplCopyWith<_$EarthquakeMetadataImpl> get copyWith =>
      __$$EarthquakeMetadataImplCopyWithImpl<_$EarthquakeMetadataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EarthquakeMetadataImplToJson(
      this,
    );
  }
}

abstract class _EarthquakeMetadata implements EarthquakeMetadata {
  const factory _EarthquakeMetadata(
      {required final int generated,
      required final String url,
      required final String title,
      required final int status,
      required final String api,
      required final int count}) = _$EarthquakeMetadataImpl;

  factory _EarthquakeMetadata.fromJson(Map<String, dynamic> json) =
      _$EarthquakeMetadataImpl.fromJson;

  @override
  int get generated;
  @override
  String get url;
  @override
  String get title;
  @override
  int get status;
  @override
  String get api;
  @override
  int get count;
  @override
  @JsonKey(ignore: true)
  _$$EarthquakeMetadataImplCopyWith<_$EarthquakeMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EarthquakeFeature _$EarthquakeFeatureFromJson(Map<String, dynamic> json) {
  return _EarthquakeFeature.fromJson(json);
}

/// @nodoc
mixin _$EarthquakeFeature {
  String get type => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  EarthquakeProperties get properties => throw _privateConstructorUsedError;
  EarthquakeGeometry get geometry => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EarthquakeFeatureCopyWith<EarthquakeFeature> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EarthquakeFeatureCopyWith<$Res> {
  factory $EarthquakeFeatureCopyWith(
          EarthquakeFeature value, $Res Function(EarthquakeFeature) then) =
      _$EarthquakeFeatureCopyWithImpl<$Res, EarthquakeFeature>;
  @useResult
  $Res call(
      {String type,
      String id,
      EarthquakeProperties properties,
      EarthquakeGeometry geometry});

  $EarthquakePropertiesCopyWith<$Res> get properties;
  $EarthquakeGeometryCopyWith<$Res> get geometry;
}

/// @nodoc
class _$EarthquakeFeatureCopyWithImpl<$Res, $Val extends EarthquakeFeature>
    implements $EarthquakeFeatureCopyWith<$Res> {
  _$EarthquakeFeatureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = null,
    Object? properties = null,
    Object? geometry = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as EarthquakeProperties,
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as EarthquakeGeometry,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $EarthquakePropertiesCopyWith<$Res> get properties {
    return $EarthquakePropertiesCopyWith<$Res>(_value.properties, (value) {
      return _then(_value.copyWith(properties: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $EarthquakeGeometryCopyWith<$Res> get geometry {
    return $EarthquakeGeometryCopyWith<$Res>(_value.geometry, (value) {
      return _then(_value.copyWith(geometry: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EarthquakeFeatureImplCopyWith<$Res>
    implements $EarthquakeFeatureCopyWith<$Res> {
  factory _$$EarthquakeFeatureImplCopyWith(_$EarthquakeFeatureImpl value,
          $Res Function(_$EarthquakeFeatureImpl) then) =
      __$$EarthquakeFeatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      String id,
      EarthquakeProperties properties,
      EarthquakeGeometry geometry});

  @override
  $EarthquakePropertiesCopyWith<$Res> get properties;
  @override
  $EarthquakeGeometryCopyWith<$Res> get geometry;
}

/// @nodoc
class __$$EarthquakeFeatureImplCopyWithImpl<$Res>
    extends _$EarthquakeFeatureCopyWithImpl<$Res, _$EarthquakeFeatureImpl>
    implements _$$EarthquakeFeatureImplCopyWith<$Res> {
  __$$EarthquakeFeatureImplCopyWithImpl(_$EarthquakeFeatureImpl _value,
      $Res Function(_$EarthquakeFeatureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = null,
    Object? properties = null,
    Object? geometry = null,
  }) {
    return _then(_$EarthquakeFeatureImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as EarthquakeProperties,
      geometry: null == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as EarthquakeGeometry,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EarthquakeFeatureImpl extends _EarthquakeFeature {
  const _$EarthquakeFeatureImpl(
      {required this.type,
      required this.id,
      required this.properties,
      required this.geometry})
      : super._();

  factory _$EarthquakeFeatureImpl.fromJson(Map<String, dynamic> json) =>
      _$$EarthquakeFeatureImplFromJson(json);

  @override
  final String type;
  @override
  final String id;
  @override
  final EarthquakeProperties properties;
  @override
  final EarthquakeGeometry geometry;

  @override
  String toString() {
    return 'EarthquakeFeature(type: $type, id: $id, properties: $properties, geometry: $geometry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EarthquakeFeatureImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.properties, properties) ||
                other.properties == properties) &&
            (identical(other.geometry, geometry) ||
                other.geometry == geometry));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, id, properties, geometry);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EarthquakeFeatureImplCopyWith<_$EarthquakeFeatureImpl> get copyWith =>
      __$$EarthquakeFeatureImplCopyWithImpl<_$EarthquakeFeatureImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EarthquakeFeatureImplToJson(
      this,
    );
  }
}

abstract class _EarthquakeFeature extends EarthquakeFeature {
  const factory _EarthquakeFeature(
      {required final String type,
      required final String id,
      required final EarthquakeProperties properties,
      required final EarthquakeGeometry geometry}) = _$EarthquakeFeatureImpl;
  const _EarthquakeFeature._() : super._();

  factory _EarthquakeFeature.fromJson(Map<String, dynamic> json) =
      _$EarthquakeFeatureImpl.fromJson;

  @override
  String get type;
  @override
  String get id;
  @override
  EarthquakeProperties get properties;
  @override
  EarthquakeGeometry get geometry;
  @override
  @JsonKey(ignore: true)
  _$$EarthquakeFeatureImplCopyWith<_$EarthquakeFeatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EarthquakeProperties _$EarthquakePropertiesFromJson(Map<String, dynamic> json) {
  return _EarthquakeProperties.fromJson(json);
}

/// @nodoc
mixin _$EarthquakeProperties {
  double? get mag => throw _privateConstructorUsedError;
  String? get place => throw _privateConstructorUsedError;
  int? get time => throw _privateConstructorUsedError;
  int? get updated => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get detail => throw _privateConstructorUsedError;
  int? get felt => throw _privateConstructorUsedError;
  double? get cdi => throw _privateConstructorUsedError;
  double? get mmi => throw _privateConstructorUsedError;
  String? get alert => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  int? get tsunami => throw _privateConstructorUsedError;
  int? get sig => throw _privateConstructorUsedError;
  String? get net => throw _privateConstructorUsedError;
  String? get code => throw _privateConstructorUsedError;
  String? get types => throw _privateConstructorUsedError;
  int? get nst => throw _privateConstructorUsedError;
  double? get dmin => throw _privateConstructorUsedError;
  double? get rms => throw _privateConstructorUsedError;
  double? get gap => throw _privateConstructorUsedError;
  String? get magType => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EarthquakePropertiesCopyWith<EarthquakeProperties> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EarthquakePropertiesCopyWith<$Res> {
  factory $EarthquakePropertiesCopyWith(EarthquakeProperties value,
          $Res Function(EarthquakeProperties) then) =
      _$EarthquakePropertiesCopyWithImpl<$Res, EarthquakeProperties>;
  @useResult
  $Res call(
      {double? mag,
      String? place,
      int? time,
      int? updated,
      String? url,
      String? detail,
      int? felt,
      double? cdi,
      double? mmi,
      String? alert,
      String? status,
      int? tsunami,
      int? sig,
      String? net,
      String? code,
      String? types,
      int? nst,
      double? dmin,
      double? rms,
      double? gap,
      String? magType,
      String? type,
      String? title});
}

/// @nodoc
class _$EarthquakePropertiesCopyWithImpl<$Res,
        $Val extends EarthquakeProperties>
    implements $EarthquakePropertiesCopyWith<$Res> {
  _$EarthquakePropertiesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mag = freezed,
    Object? place = freezed,
    Object? time = freezed,
    Object? updated = freezed,
    Object? url = freezed,
    Object? detail = freezed,
    Object? felt = freezed,
    Object? cdi = freezed,
    Object? mmi = freezed,
    Object? alert = freezed,
    Object? status = freezed,
    Object? tsunami = freezed,
    Object? sig = freezed,
    Object? net = freezed,
    Object? code = freezed,
    Object? types = freezed,
    Object? nst = freezed,
    Object? dmin = freezed,
    Object? rms = freezed,
    Object? gap = freezed,
    Object? magType = freezed,
    Object? type = freezed,
    Object? title = freezed,
  }) {
    return _then(_value.copyWith(
      mag: freezed == mag
          ? _value.mag
          : mag // ignore: cast_nullable_to_non_nullable
              as double?,
      place: freezed == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as String?,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int?,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      detail: freezed == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
      felt: freezed == felt
          ? _value.felt
          : felt // ignore: cast_nullable_to_non_nullable
              as int?,
      cdi: freezed == cdi
          ? _value.cdi
          : cdi // ignore: cast_nullable_to_non_nullable
              as double?,
      mmi: freezed == mmi
          ? _value.mmi
          : mmi // ignore: cast_nullable_to_non_nullable
              as double?,
      alert: freezed == alert
          ? _value.alert
          : alert // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      tsunami: freezed == tsunami
          ? _value.tsunami
          : tsunami // ignore: cast_nullable_to_non_nullable
              as int?,
      sig: freezed == sig
          ? _value.sig
          : sig // ignore: cast_nullable_to_non_nullable
              as int?,
      net: freezed == net
          ? _value.net
          : net // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      types: freezed == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as String?,
      nst: freezed == nst
          ? _value.nst
          : nst // ignore: cast_nullable_to_non_nullable
              as int?,
      dmin: freezed == dmin
          ? _value.dmin
          : dmin // ignore: cast_nullable_to_non_nullable
              as double?,
      rms: freezed == rms
          ? _value.rms
          : rms // ignore: cast_nullable_to_non_nullable
              as double?,
      gap: freezed == gap
          ? _value.gap
          : gap // ignore: cast_nullable_to_non_nullable
              as double?,
      magType: freezed == magType
          ? _value.magType
          : magType // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EarthquakePropertiesImplCopyWith<$Res>
    implements $EarthquakePropertiesCopyWith<$Res> {
  factory _$$EarthquakePropertiesImplCopyWith(_$EarthquakePropertiesImpl value,
          $Res Function(_$EarthquakePropertiesImpl) then) =
      __$$EarthquakePropertiesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double? mag,
      String? place,
      int? time,
      int? updated,
      String? url,
      String? detail,
      int? felt,
      double? cdi,
      double? mmi,
      String? alert,
      String? status,
      int? tsunami,
      int? sig,
      String? net,
      String? code,
      String? types,
      int? nst,
      double? dmin,
      double? rms,
      double? gap,
      String? magType,
      String? type,
      String? title});
}

/// @nodoc
class __$$EarthquakePropertiesImplCopyWithImpl<$Res>
    extends _$EarthquakePropertiesCopyWithImpl<$Res, _$EarthquakePropertiesImpl>
    implements _$$EarthquakePropertiesImplCopyWith<$Res> {
  __$$EarthquakePropertiesImplCopyWithImpl(_$EarthquakePropertiesImpl _value,
      $Res Function(_$EarthquakePropertiesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mag = freezed,
    Object? place = freezed,
    Object? time = freezed,
    Object? updated = freezed,
    Object? url = freezed,
    Object? detail = freezed,
    Object? felt = freezed,
    Object? cdi = freezed,
    Object? mmi = freezed,
    Object? alert = freezed,
    Object? status = freezed,
    Object? tsunami = freezed,
    Object? sig = freezed,
    Object? net = freezed,
    Object? code = freezed,
    Object? types = freezed,
    Object? nst = freezed,
    Object? dmin = freezed,
    Object? rms = freezed,
    Object? gap = freezed,
    Object? magType = freezed,
    Object? type = freezed,
    Object? title = freezed,
  }) {
    return _then(_$EarthquakePropertiesImpl(
      mag: freezed == mag
          ? _value.mag
          : mag // ignore: cast_nullable_to_non_nullable
              as double?,
      place: freezed == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as String?,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int?,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as int?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      detail: freezed == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
      felt: freezed == felt
          ? _value.felt
          : felt // ignore: cast_nullable_to_non_nullable
              as int?,
      cdi: freezed == cdi
          ? _value.cdi
          : cdi // ignore: cast_nullable_to_non_nullable
              as double?,
      mmi: freezed == mmi
          ? _value.mmi
          : mmi // ignore: cast_nullable_to_non_nullable
              as double?,
      alert: freezed == alert
          ? _value.alert
          : alert // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      tsunami: freezed == tsunami
          ? _value.tsunami
          : tsunami // ignore: cast_nullable_to_non_nullable
              as int?,
      sig: freezed == sig
          ? _value.sig
          : sig // ignore: cast_nullable_to_non_nullable
              as int?,
      net: freezed == net
          ? _value.net
          : net // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      types: freezed == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as String?,
      nst: freezed == nst
          ? _value.nst
          : nst // ignore: cast_nullable_to_non_nullable
              as int?,
      dmin: freezed == dmin
          ? _value.dmin
          : dmin // ignore: cast_nullable_to_non_nullable
              as double?,
      rms: freezed == rms
          ? _value.rms
          : rms // ignore: cast_nullable_to_non_nullable
              as double?,
      gap: freezed == gap
          ? _value.gap
          : gap // ignore: cast_nullable_to_non_nullable
              as double?,
      magType: freezed == magType
          ? _value.magType
          : magType // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EarthquakePropertiesImpl implements _EarthquakeProperties {
  const _$EarthquakePropertiesImpl(
      {this.mag,
      this.place,
      this.time,
      this.updated,
      this.url,
      this.detail,
      this.felt,
      this.cdi,
      this.mmi,
      this.alert,
      this.status,
      this.tsunami,
      this.sig,
      this.net,
      this.code,
      this.types,
      this.nst,
      this.dmin,
      this.rms,
      this.gap,
      this.magType,
      this.type,
      this.title});

  factory _$EarthquakePropertiesImpl.fromJson(Map<String, dynamic> json) =>
      _$$EarthquakePropertiesImplFromJson(json);

  @override
  final double? mag;
  @override
  final String? place;
  @override
  final int? time;
  @override
  final int? updated;
  @override
  final String? url;
  @override
  final String? detail;
  @override
  final int? felt;
  @override
  final double? cdi;
  @override
  final double? mmi;
  @override
  final String? alert;
  @override
  final String? status;
  @override
  final int? tsunami;
  @override
  final int? sig;
  @override
  final String? net;
  @override
  final String? code;
  @override
  final String? types;
  @override
  final int? nst;
  @override
  final double? dmin;
  @override
  final double? rms;
  @override
  final double? gap;
  @override
  final String? magType;
  @override
  final String? type;
  @override
  final String? title;

  @override
  String toString() {
    return 'EarthquakeProperties(mag: $mag, place: $place, time: $time, updated: $updated, url: $url, detail: $detail, felt: $felt, cdi: $cdi, mmi: $mmi, alert: $alert, status: $status, tsunami: $tsunami, sig: $sig, net: $net, code: $code, types: $types, nst: $nst, dmin: $dmin, rms: $rms, gap: $gap, magType: $magType, type: $type, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EarthquakePropertiesImpl &&
            (identical(other.mag, mag) || other.mag == mag) &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.updated, updated) || other.updated == updated) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.felt, felt) || other.felt == felt) &&
            (identical(other.cdi, cdi) || other.cdi == cdi) &&
            (identical(other.mmi, mmi) || other.mmi == mmi) &&
            (identical(other.alert, alert) || other.alert == alert) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.tsunami, tsunami) || other.tsunami == tsunami) &&
            (identical(other.sig, sig) || other.sig == sig) &&
            (identical(other.net, net) || other.net == net) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.types, types) || other.types == types) &&
            (identical(other.nst, nst) || other.nst == nst) &&
            (identical(other.dmin, dmin) || other.dmin == dmin) &&
            (identical(other.rms, rms) || other.rms == rms) &&
            (identical(other.gap, gap) || other.gap == gap) &&
            (identical(other.magType, magType) || other.magType == magType) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        mag,
        place,
        time,
        updated,
        url,
        detail,
        felt,
        cdi,
        mmi,
        alert,
        status,
        tsunami,
        sig,
        net,
        code,
        types,
        nst,
        dmin,
        rms,
        gap,
        magType,
        type,
        title
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EarthquakePropertiesImplCopyWith<_$EarthquakePropertiesImpl>
      get copyWith =>
          __$$EarthquakePropertiesImplCopyWithImpl<_$EarthquakePropertiesImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EarthquakePropertiesImplToJson(
      this,
    );
  }
}

abstract class _EarthquakeProperties implements EarthquakeProperties {
  const factory _EarthquakeProperties(
      {final double? mag,
      final String? place,
      final int? time,
      final int? updated,
      final String? url,
      final String? detail,
      final int? felt,
      final double? cdi,
      final double? mmi,
      final String? alert,
      final String? status,
      final int? tsunami,
      final int? sig,
      final String? net,
      final String? code,
      final String? types,
      final int? nst,
      final double? dmin,
      final double? rms,
      final double? gap,
      final String? magType,
      final String? type,
      final String? title}) = _$EarthquakePropertiesImpl;

  factory _EarthquakeProperties.fromJson(Map<String, dynamic> json) =
      _$EarthquakePropertiesImpl.fromJson;

  @override
  double? get mag;
  @override
  String? get place;
  @override
  int? get time;
  @override
  int? get updated;
  @override
  String? get url;
  @override
  String? get detail;
  @override
  int? get felt;
  @override
  double? get cdi;
  @override
  double? get mmi;
  @override
  String? get alert;
  @override
  String? get status;
  @override
  int? get tsunami;
  @override
  int? get sig;
  @override
  String? get net;
  @override
  String? get code;
  @override
  String? get types;
  @override
  int? get nst;
  @override
  double? get dmin;
  @override
  double? get rms;
  @override
  double? get gap;
  @override
  String? get magType;
  @override
  String? get type;
  @override
  String? get title;
  @override
  @JsonKey(ignore: true)
  _$$EarthquakePropertiesImplCopyWith<_$EarthquakePropertiesImpl>
      get copyWith => throw _privateConstructorUsedError;
}

EarthquakeGeometry _$EarthquakeGeometryFromJson(Map<String, dynamic> json) {
  return _EarthquakeGeometry.fromJson(json);
}

/// @nodoc
mixin _$EarthquakeGeometry {
  String get type => throw _privateConstructorUsedError;
  List<double> get coordinates => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EarthquakeGeometryCopyWith<EarthquakeGeometry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EarthquakeGeometryCopyWith<$Res> {
  factory $EarthquakeGeometryCopyWith(
          EarthquakeGeometry value, $Res Function(EarthquakeGeometry) then) =
      _$EarthquakeGeometryCopyWithImpl<$Res, EarthquakeGeometry>;
  @useResult
  $Res call({String type, List<double> coordinates});
}

/// @nodoc
class _$EarthquakeGeometryCopyWithImpl<$Res, $Val extends EarthquakeGeometry>
    implements $EarthquakeGeometryCopyWith<$Res> {
  _$EarthquakeGeometryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? coordinates = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EarthquakeGeometryImplCopyWith<$Res>
    implements $EarthquakeGeometryCopyWith<$Res> {
  factory _$$EarthquakeGeometryImplCopyWith(_$EarthquakeGeometryImpl value,
          $Res Function(_$EarthquakeGeometryImpl) then) =
      __$$EarthquakeGeometryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, List<double> coordinates});
}

/// @nodoc
class __$$EarthquakeGeometryImplCopyWithImpl<$Res>
    extends _$EarthquakeGeometryCopyWithImpl<$Res, _$EarthquakeGeometryImpl>
    implements _$$EarthquakeGeometryImplCopyWith<$Res> {
  __$$EarthquakeGeometryImplCopyWithImpl(_$EarthquakeGeometryImpl _value,
      $Res Function(_$EarthquakeGeometryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? coordinates = null,
  }) {
    return _then(_$EarthquakeGeometryImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: null == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EarthquakeGeometryImpl implements _EarthquakeGeometry {
  const _$EarthquakeGeometryImpl(
      {required this.type, required final List<double> coordinates})
      : _coordinates = coordinates;

  factory _$EarthquakeGeometryImpl.fromJson(Map<String, dynamic> json) =>
      _$$EarthquakeGeometryImplFromJson(json);

  @override
  final String type;
  final List<double> _coordinates;
  @override
  List<double> get coordinates {
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coordinates);
  }

  @override
  String toString() {
    return 'EarthquakeGeometry(type: $type, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EarthquakeGeometryImpl &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, type, const DeepCollectionEquality().hash(_coordinates));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EarthquakeGeometryImplCopyWith<_$EarthquakeGeometryImpl> get copyWith =>
      __$$EarthquakeGeometryImplCopyWithImpl<_$EarthquakeGeometryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EarthquakeGeometryImplToJson(
      this,
    );
  }
}

abstract class _EarthquakeGeometry implements EarthquakeGeometry {
  const factory _EarthquakeGeometry(
      {required final String type,
      required final List<double> coordinates}) = _$EarthquakeGeometryImpl;

  factory _EarthquakeGeometry.fromJson(Map<String, dynamic> json) =
      _$EarthquakeGeometryImpl.fromJson;

  @override
  String get type;
  @override
  List<double> get coordinates;
  @override
  @JsonKey(ignore: true)
  _$$EarthquakeGeometryImplCopyWith<_$EarthquakeGeometryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
