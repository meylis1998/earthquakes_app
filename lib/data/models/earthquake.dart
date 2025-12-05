import 'package:freezed_annotation/freezed_annotation.dart';

part 'earthquake.freezed.dart';
part 'earthquake.g.dart';

@freezed
class EarthquakeResponse with _$EarthquakeResponse {
  const factory EarthquakeResponse({
    required String type,
    required EarthquakeMetadata metadata,
    required List<EarthquakeFeature> features,
    List<double>? bbox,
  }) = _EarthquakeResponse;

  factory EarthquakeResponse.fromJson(Map<String, dynamic> json) =>
      _$EarthquakeResponseFromJson(json);
}

@freezed
class EarthquakeMetadata with _$EarthquakeMetadata {
  const factory EarthquakeMetadata({
    required int generated,
    required String url,
    required String title,
    required int status,
    required String api,
    required int count,
  }) = _EarthquakeMetadata;

  factory EarthquakeMetadata.fromJson(Map<String, dynamic> json) =>
      _$EarthquakeMetadataFromJson(json);
}

@freezed
class EarthquakeFeature with _$EarthquakeFeature {
  const EarthquakeFeature._();

  const factory EarthquakeFeature({
    required String type,
    required String id,
    required EarthquakeProperties properties,
    required EarthquakeGeometry geometry,
  }) = _EarthquakeFeature;

  factory EarthquakeFeature.fromJson(Map<String, dynamic> json) =>
      _$EarthquakeFeatureFromJson(json);

  double get latitude => geometry.coordinates[1];
  double get longitude => geometry.coordinates[0];
  double get depth => geometry.coordinates.length > 2 ? geometry.coordinates[2] : 0;

  DateTime get time => DateTime.fromMillisecondsSinceEpoch(
    properties.time ?? 0,
    isUtc: true,
  );

  String get magnitudeClass {
    final mag = properties.mag ?? 0;
    if (mag < 2.0) return 'Micro';
    if (mag < 3.0) return 'Minor';
    if (mag < 4.0) return 'Light';
    if (mag < 5.0) return 'Moderate';
    if (mag < 6.0) return 'Strong';
    if (mag < 7.0) return 'Major';
    if (mag < 8.0) return 'Great';
    return 'Massive';
  }

  bool get hasTsunamiWarning => properties.tsunami == 1;
}

@freezed
class EarthquakeProperties with _$EarthquakeProperties {
  const factory EarthquakeProperties({
    double? mag,
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
    String? title,
  }) = _EarthquakeProperties;

  factory EarthquakeProperties.fromJson(Map<String, dynamic> json) =>
      _$EarthquakePropertiesFromJson(json);
}

@freezed
class EarthquakeGeometry with _$EarthquakeGeometry {
  const factory EarthquakeGeometry({
    required String type,
    required List<double> coordinates,
  }) = _EarthquakeGeometry;

  factory EarthquakeGeometry.fromJson(Map<String, dynamic> json) =>
      _$EarthquakeGeometryFromJson(json);
}
