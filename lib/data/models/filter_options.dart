import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_options.freezed.dart';

enum MagnitudeFilter {
  all('all', 'All'),
  m1('1.0', 'M1.0+'),
  m25('2.5', 'M2.5+'),
  m45('4.5', 'M4.5+'),
  significant('significant', 'Significant');

  const MagnitudeFilter(this.value, this.label);
  final String value;
  final String label;
}

enum TimePeriod {
  hour('hour', 'Past Hour'),
  day('day', 'Past Day'),
  week('week', 'Past 7 Days'),
  month('month', 'Past 30 Days');

  const TimePeriod(this.value, this.label);
  final String value;
  final String label;
}

@freezed
class FilterOptions with _$FilterOptions {
  const factory FilterOptions({
    @Default(MagnitudeFilter.m25) MagnitudeFilter magnitude,
    @Default(TimePeriod.day) TimePeriod period,
  }) = _FilterOptions;
}

@freezed
class QueryOptions with _$QueryOptions {
  const factory QueryOptions({
    DateTime? startTime,
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
    @Default('time') String orderBy,
    String? alertLevel,
  }) = _QueryOptions;
}
