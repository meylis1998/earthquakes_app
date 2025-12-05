// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'earthquake.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EarthquakeResponseImpl _$$EarthquakeResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$EarthquakeResponseImpl(
      type: json['type'] as String,
      metadata:
          EarthquakeMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      features: (json['features'] as List<dynamic>)
          .map((e) => EarthquakeFeature.fromJson(e as Map<String, dynamic>))
          .toList(),
      bbox: (json['bbox'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$$EarthquakeResponseImplToJson(
        _$EarthquakeResponseImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'metadata': instance.metadata,
      'features': instance.features,
      'bbox': instance.bbox,
    };

_$EarthquakeMetadataImpl _$$EarthquakeMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$EarthquakeMetadataImpl(
      generated: (json['generated'] as num).toInt(),
      url: json['url'] as String,
      title: json['title'] as String,
      status: (json['status'] as num).toInt(),
      api: json['api'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$$EarthquakeMetadataImplToJson(
        _$EarthquakeMetadataImpl instance) =>
    <String, dynamic>{
      'generated': instance.generated,
      'url': instance.url,
      'title': instance.title,
      'status': instance.status,
      'api': instance.api,
      'count': instance.count,
    };

_$EarthquakeFeatureImpl _$$EarthquakeFeatureImplFromJson(
        Map<String, dynamic> json) =>
    _$EarthquakeFeatureImpl(
      type: json['type'] as String,
      id: json['id'] as String,
      properties: EarthquakeProperties.fromJson(
          json['properties'] as Map<String, dynamic>),
      geometry:
          EarthquakeGeometry.fromJson(json['geometry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$EarthquakeFeatureImplToJson(
        _$EarthquakeFeatureImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'properties': instance.properties,
      'geometry': instance.geometry,
    };

_$EarthquakePropertiesImpl _$$EarthquakePropertiesImplFromJson(
        Map<String, dynamic> json) =>
    _$EarthquakePropertiesImpl(
      mag: (json['mag'] as num?)?.toDouble(),
      place: json['place'] as String?,
      time: (json['time'] as num?)?.toInt(),
      updated: (json['updated'] as num?)?.toInt(),
      url: json['url'] as String?,
      detail: json['detail'] as String?,
      felt: (json['felt'] as num?)?.toInt(),
      cdi: (json['cdi'] as num?)?.toDouble(),
      mmi: (json['mmi'] as num?)?.toDouble(),
      alert: json['alert'] as String?,
      status: json['status'] as String?,
      tsunami: (json['tsunami'] as num?)?.toInt(),
      sig: (json['sig'] as num?)?.toInt(),
      net: json['net'] as String?,
      code: json['code'] as String?,
      types: json['types'] as String?,
      nst: (json['nst'] as num?)?.toInt(),
      dmin: (json['dmin'] as num?)?.toDouble(),
      rms: (json['rms'] as num?)?.toDouble(),
      gap: (json['gap'] as num?)?.toDouble(),
      magType: json['magType'] as String?,
      type: json['type'] as String?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$$EarthquakePropertiesImplToJson(
        _$EarthquakePropertiesImpl instance) =>
    <String, dynamic>{
      'mag': instance.mag,
      'place': instance.place,
      'time': instance.time,
      'updated': instance.updated,
      'url': instance.url,
      'detail': instance.detail,
      'felt': instance.felt,
      'cdi': instance.cdi,
      'mmi': instance.mmi,
      'alert': instance.alert,
      'status': instance.status,
      'tsunami': instance.tsunami,
      'sig': instance.sig,
      'net': instance.net,
      'code': instance.code,
      'types': instance.types,
      'nst': instance.nst,
      'dmin': instance.dmin,
      'rms': instance.rms,
      'gap': instance.gap,
      'magType': instance.magType,
      'type': instance.type,
      'title': instance.title,
    };

_$EarthquakeGeometryImpl _$$EarthquakeGeometryImplFromJson(
        Map<String, dynamic> json) =>
    _$EarthquakeGeometryImpl(
      type: json['type'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$$EarthquakeGeometryImplToJson(
        _$EarthquakeGeometryImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
