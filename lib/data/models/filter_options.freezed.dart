// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FilterOptions {
  MagnitudeFilter get magnitude => throw _privateConstructorUsedError;
  TimePeriod get period => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FilterOptionsCopyWith<FilterOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FilterOptionsCopyWith<$Res> {
  factory $FilterOptionsCopyWith(
          FilterOptions value, $Res Function(FilterOptions) then) =
      _$FilterOptionsCopyWithImpl<$Res, FilterOptions>;
  @useResult
  $Res call({MagnitudeFilter magnitude, TimePeriod period});
}

/// @nodoc
class _$FilterOptionsCopyWithImpl<$Res, $Val extends FilterOptions>
    implements $FilterOptionsCopyWith<$Res> {
  _$FilterOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? magnitude = null,
    Object? period = null,
  }) {
    return _then(_value.copyWith(
      magnitude: null == magnitude
          ? _value.magnitude
          : magnitude // ignore: cast_nullable_to_non_nullable
              as MagnitudeFilter,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as TimePeriod,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FilterOptionsImplCopyWith<$Res>
    implements $FilterOptionsCopyWith<$Res> {
  factory _$$FilterOptionsImplCopyWith(
          _$FilterOptionsImpl value, $Res Function(_$FilterOptionsImpl) then) =
      __$$FilterOptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MagnitudeFilter magnitude, TimePeriod period});
}

/// @nodoc
class __$$FilterOptionsImplCopyWithImpl<$Res>
    extends _$FilterOptionsCopyWithImpl<$Res, _$FilterOptionsImpl>
    implements _$$FilterOptionsImplCopyWith<$Res> {
  __$$FilterOptionsImplCopyWithImpl(
      _$FilterOptionsImpl _value, $Res Function(_$FilterOptionsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? magnitude = null,
    Object? period = null,
  }) {
    return _then(_$FilterOptionsImpl(
      magnitude: null == magnitude
          ? _value.magnitude
          : magnitude // ignore: cast_nullable_to_non_nullable
              as MagnitudeFilter,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as TimePeriod,
    ));
  }
}

/// @nodoc

class _$FilterOptionsImpl implements _FilterOptions {
  const _$FilterOptionsImpl(
      {this.magnitude = MagnitudeFilter.m25, this.period = TimePeriod.day});

  @override
  @JsonKey()
  final MagnitudeFilter magnitude;
  @override
  @JsonKey()
  final TimePeriod period;

  @override
  String toString() {
    return 'FilterOptions(magnitude: $magnitude, period: $period)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FilterOptionsImpl &&
            (identical(other.magnitude, magnitude) ||
                other.magnitude == magnitude) &&
            (identical(other.period, period) || other.period == period));
  }

  @override
  int get hashCode => Object.hash(runtimeType, magnitude, period);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FilterOptionsImplCopyWith<_$FilterOptionsImpl> get copyWith =>
      __$$FilterOptionsImplCopyWithImpl<_$FilterOptionsImpl>(this, _$identity);
}

abstract class _FilterOptions implements FilterOptions {
  const factory _FilterOptions(
      {final MagnitudeFilter magnitude,
      final TimePeriod period}) = _$FilterOptionsImpl;

  @override
  MagnitudeFilter get magnitude;
  @override
  TimePeriod get period;
  @override
  @JsonKey(ignore: true)
  _$$FilterOptionsImplCopyWith<_$FilterOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$QueryOptions {
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  double? get minMagnitude => throw _privateConstructorUsedError;
  double? get maxMagnitude => throw _privateConstructorUsedError;
  double? get minLatitude => throw _privateConstructorUsedError;
  double? get maxLatitude => throw _privateConstructorUsedError;
  double? get minLongitude => throw _privateConstructorUsedError;
  double? get maxLongitude => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  double? get maxRadiusKm => throw _privateConstructorUsedError;
  int? get limit => throw _privateConstructorUsedError;
  String get orderBy => throw _privateConstructorUsedError;
  String? get alertLevel => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QueryOptionsCopyWith<QueryOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QueryOptionsCopyWith<$Res> {
  factory $QueryOptionsCopyWith(
          QueryOptions value, $Res Function(QueryOptions) then) =
      _$QueryOptionsCopyWithImpl<$Res, QueryOptions>;
  @useResult
  $Res call(
      {DateTime? startTime,
      DateTime? endTime,
      double? minMagnitude,
      double? maxMagnitude,
      double? minLatitude,
      double? maxLatitude,
      double? minLongitude,
      double? maxLongitude,
      double? latitude,
      double? longitude,
      double? maxRadiusKm,
      int? limit,
      String orderBy,
      String? alertLevel});
}

/// @nodoc
class _$QueryOptionsCopyWithImpl<$Res, $Val extends QueryOptions>
    implements $QueryOptionsCopyWith<$Res> {
  _$QueryOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? minMagnitude = freezed,
    Object? maxMagnitude = freezed,
    Object? minLatitude = freezed,
    Object? maxLatitude = freezed,
    Object? minLongitude = freezed,
    Object? maxLongitude = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? maxRadiusKm = freezed,
    Object? limit = freezed,
    Object? orderBy = null,
    Object? alertLevel = freezed,
  }) {
    return _then(_value.copyWith(
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      minMagnitude: freezed == minMagnitude
          ? _value.minMagnitude
          : minMagnitude // ignore: cast_nullable_to_non_nullable
              as double?,
      maxMagnitude: freezed == maxMagnitude
          ? _value.maxMagnitude
          : maxMagnitude // ignore: cast_nullable_to_non_nullable
              as double?,
      minLatitude: freezed == minLatitude
          ? _value.minLatitude
          : minLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      maxLatitude: freezed == maxLatitude
          ? _value.maxLatitude
          : maxLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      minLongitude: freezed == minLongitude
          ? _value.minLongitude
          : minLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      maxLongitude: freezed == maxLongitude
          ? _value.maxLongitude
          : maxLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      maxRadiusKm: freezed == maxRadiusKm
          ? _value.maxRadiusKm
          : maxRadiusKm // ignore: cast_nullable_to_non_nullable
              as double?,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as String,
      alertLevel: freezed == alertLevel
          ? _value.alertLevel
          : alertLevel // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QueryOptionsImplCopyWith<$Res>
    implements $QueryOptionsCopyWith<$Res> {
  factory _$$QueryOptionsImplCopyWith(
          _$QueryOptionsImpl value, $Res Function(_$QueryOptionsImpl) then) =
      __$$QueryOptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime? startTime,
      DateTime? endTime,
      double? minMagnitude,
      double? maxMagnitude,
      double? minLatitude,
      double? maxLatitude,
      double? minLongitude,
      double? maxLongitude,
      double? latitude,
      double? longitude,
      double? maxRadiusKm,
      int? limit,
      String orderBy,
      String? alertLevel});
}

/// @nodoc
class __$$QueryOptionsImplCopyWithImpl<$Res>
    extends _$QueryOptionsCopyWithImpl<$Res, _$QueryOptionsImpl>
    implements _$$QueryOptionsImplCopyWith<$Res> {
  __$$QueryOptionsImplCopyWithImpl(
      _$QueryOptionsImpl _value, $Res Function(_$QueryOptionsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? minMagnitude = freezed,
    Object? maxMagnitude = freezed,
    Object? minLatitude = freezed,
    Object? maxLatitude = freezed,
    Object? minLongitude = freezed,
    Object? maxLongitude = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? maxRadiusKm = freezed,
    Object? limit = freezed,
    Object? orderBy = null,
    Object? alertLevel = freezed,
  }) {
    return _then(_$QueryOptionsImpl(
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      minMagnitude: freezed == minMagnitude
          ? _value.minMagnitude
          : minMagnitude // ignore: cast_nullable_to_non_nullable
              as double?,
      maxMagnitude: freezed == maxMagnitude
          ? _value.maxMagnitude
          : maxMagnitude // ignore: cast_nullable_to_non_nullable
              as double?,
      minLatitude: freezed == minLatitude
          ? _value.minLatitude
          : minLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      maxLatitude: freezed == maxLatitude
          ? _value.maxLatitude
          : maxLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      minLongitude: freezed == minLongitude
          ? _value.minLongitude
          : minLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      maxLongitude: freezed == maxLongitude
          ? _value.maxLongitude
          : maxLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      maxRadiusKm: freezed == maxRadiusKm
          ? _value.maxRadiusKm
          : maxRadiusKm // ignore: cast_nullable_to_non_nullable
              as double?,
      limit: freezed == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int?,
      orderBy: null == orderBy
          ? _value.orderBy
          : orderBy // ignore: cast_nullable_to_non_nullable
              as String,
      alertLevel: freezed == alertLevel
          ? _value.alertLevel
          : alertLevel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$QueryOptionsImpl implements _QueryOptions {
  const _$QueryOptionsImpl(
      {this.startTime,
      this.endTime,
      this.minMagnitude,
      this.maxMagnitude,
      this.minLatitude,
      this.maxLatitude,
      this.minLongitude,
      this.maxLongitude,
      this.latitude,
      this.longitude,
      this.maxRadiusKm,
      this.limit,
      this.orderBy = 'time',
      this.alertLevel});

  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;
  @override
  final double? minMagnitude;
  @override
  final double? maxMagnitude;
  @override
  final double? minLatitude;
  @override
  final double? maxLatitude;
  @override
  final double? minLongitude;
  @override
  final double? maxLongitude;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final double? maxRadiusKm;
  @override
  final int? limit;
  @override
  @JsonKey()
  final String orderBy;
  @override
  final String? alertLevel;

  @override
  String toString() {
    return 'QueryOptions(startTime: $startTime, endTime: $endTime, minMagnitude: $minMagnitude, maxMagnitude: $maxMagnitude, minLatitude: $minLatitude, maxLatitude: $maxLatitude, minLongitude: $minLongitude, maxLongitude: $maxLongitude, latitude: $latitude, longitude: $longitude, maxRadiusKm: $maxRadiusKm, limit: $limit, orderBy: $orderBy, alertLevel: $alertLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueryOptionsImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.minMagnitude, minMagnitude) ||
                other.minMagnitude == minMagnitude) &&
            (identical(other.maxMagnitude, maxMagnitude) ||
                other.maxMagnitude == maxMagnitude) &&
            (identical(other.minLatitude, minLatitude) ||
                other.minLatitude == minLatitude) &&
            (identical(other.maxLatitude, maxLatitude) ||
                other.maxLatitude == maxLatitude) &&
            (identical(other.minLongitude, minLongitude) ||
                other.minLongitude == minLongitude) &&
            (identical(other.maxLongitude, maxLongitude) ||
                other.maxLongitude == maxLongitude) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.maxRadiusKm, maxRadiusKm) ||
                other.maxRadiusKm == maxRadiusKm) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.orderBy, orderBy) || other.orderBy == orderBy) &&
            (identical(other.alertLevel, alertLevel) ||
                other.alertLevel == alertLevel));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      startTime,
      endTime,
      minMagnitude,
      maxMagnitude,
      minLatitude,
      maxLatitude,
      minLongitude,
      maxLongitude,
      latitude,
      longitude,
      maxRadiusKm,
      limit,
      orderBy,
      alertLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QueryOptionsImplCopyWith<_$QueryOptionsImpl> get copyWith =>
      __$$QueryOptionsImplCopyWithImpl<_$QueryOptionsImpl>(this, _$identity);
}

abstract class _QueryOptions implements QueryOptions {
  const factory _QueryOptions(
      {final DateTime? startTime,
      final DateTime? endTime,
      final double? minMagnitude,
      final double? maxMagnitude,
      final double? minLatitude,
      final double? maxLatitude,
      final double? minLongitude,
      final double? maxLongitude,
      final double? latitude,
      final double? longitude,
      final double? maxRadiusKm,
      final int? limit,
      final String orderBy,
      final String? alertLevel}) = _$QueryOptionsImpl;

  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;
  @override
  double? get minMagnitude;
  @override
  double? get maxMagnitude;
  @override
  double? get minLatitude;
  @override
  double? get maxLatitude;
  @override
  double? get minLongitude;
  @override
  double? get maxLongitude;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  double? get maxRadiusKm;
  @override
  int? get limit;
  @override
  String get orderBy;
  @override
  String? get alertLevel;
  @override
  @JsonKey(ignore: true)
  _$$QueryOptionsImplCopyWith<_$QueryOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
