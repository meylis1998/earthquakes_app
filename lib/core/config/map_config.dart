/// Map tile configuration with professional free tile providers.
///
/// All providers listed here offer free tiers suitable for development
/// and limited production use. Check each provider's terms for commercial use.
library;

import 'package:flutter/material.dart';

/// Available map tile styles.
enum MapStyle {
  // CARTO Basemaps - Free up to 75k views/month (non-commercial)
  cartoPositron,
  cartoDarkMatter,
  cartoVoyager,

  // OpenFreeMap - Truly free, no limits, commercial OK
  openFreeMapPositron,
  openFreeMapLiberty,

  // Stadia Maps - Requires API key, 200k credits/month free
  stadiaAlidadeSmooth,
  stadiaAlidadeDark,
  stadiaOutdoors,
  stadiaOsmBright,

  // OpenStreetMap - For development only, strict usage policy
  osmStandard,
}

/// Map style configuration with metadata.
class MapStyleConfig {
  final MapStyle style;
  final String name;
  final String description;
  final String urlTemplate;
  final List<String> subdomains;
  final String attribution;
  final bool isDark;
  final bool requiresApiKey;
  final int maxZoom;
  final bool supportsRetina;

  const MapStyleConfig({
    required this.style,
    required this.name,
    required this.description,
    required this.urlTemplate,
    this.subdomains = const [],
    required this.attribution,
    this.isDark = false,
    this.requiresApiKey = false,
    this.maxZoom = 19,
    this.supportsRetina = true,
  });

  /// Get the full URL with optional retina support.
  String getUrl({bool retina = false}) {
    if (retina && supportsRetina) {
      return urlTemplate.replaceAll('{r}', '@2x');
    }
    return urlTemplate.replaceAll('{r}', '');
  }
}

/// Map configuration provider.
class MapConfig {
  MapConfig._();

  /// CARTO attribution text.
  static const cartoAttribution =
      '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> © <a href="https://carto.com/attributions">CARTO</a>';

  /// OpenFreeMap attribution text.
  static const openFreeMapAttribution =
      '© <a href="https://openfreemap.org">OpenFreeMap</a> © <a href="https://openmaptiles.org">OpenMapTiles</a> © <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>';

  /// Stadia Maps attribution text.
  static const stadiaAttribution =
      '© <a href="https://stadiamaps.com/">Stadia Maps</a> © <a href="https://openmaptiles.org">OpenMapTiles</a> © <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>';

  /// OpenStreetMap attribution text.
  static const osmAttribution =
      '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors';

  /// All available map styles.
  static const Map<MapStyle, MapStyleConfig> styles = {
    // ═══════════════════════════════════════════════════════════════════════
    // CARTO Basemaps
    // Free: 75,000 mapviews/month (non-commercial)
    // No API key required
    // ═══════════════════════════════════════════════════════════════════════

    MapStyle.cartoPositron: MapStyleConfig(
      style: MapStyle.cartoPositron,
      name: 'Positron',
      description: 'Clean light gray map, ideal for data visualization',
      urlTemplate:
          'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
      subdomains: ['a', 'b', 'c', 'd'],
      attribution: cartoAttribution,
      isDark: false,
      maxZoom: 20,
    ),

    MapStyle.cartoDarkMatter: MapStyleConfig(
      style: MapStyle.cartoDarkMatter,
      name: 'Dark Matter',
      description: 'Elegant dark map, perfect for highlighting data',
      urlTemplate:
          'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
      subdomains: ['a', 'b', 'c', 'd'],
      attribution: cartoAttribution,
      isDark: true,
      maxZoom: 20,
    ),

    MapStyle.cartoVoyager: MapStyleConfig(
      style: MapStyle.cartoVoyager,
      name: 'Voyager',
      description: 'Colorful map with subtle colors and clear labels',
      urlTemplate:
          'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
      subdomains: ['a', 'b', 'c', 'd'],
      attribution: cartoAttribution,
      isDark: false,
      maxZoom: 20,
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // OpenFreeMap
    // Truly FREE - No limits, no API key, commercial use allowed (MIT license)
    // ═══════════════════════════════════════════════════════════════════════

    MapStyle.openFreeMapPositron: MapStyleConfig(
      style: MapStyle.openFreeMapPositron,
      name: 'Positron (Free)',
      description: 'Unlimited free usage, no API key, commercial OK',
      urlTemplate:
          'https://tiles.openfreemap.org/styles/positron/{z}/{x}/{y}.png',
      attribution: openFreeMapAttribution,
      isDark: false,
      maxZoom: 20,
      supportsRetina: false,
    ),

    MapStyle.openFreeMapLiberty: MapStyleConfig(
      style: MapStyle.openFreeMapLiberty,
      name: 'Liberty (Free)',
      description: 'Unlimited free usage, colorful style, commercial OK',
      urlTemplate:
          'https://tiles.openfreemap.org/styles/liberty/{z}/{x}/{y}.png',
      attribution: openFreeMapAttribution,
      isDark: false,
      maxZoom: 20,
      supportsRetina: false,
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // Stadia Maps
    // Free: 200,000 credits/month (non-commercial)
    // Requires API key (free signup, no credit card)
    // ═══════════════════════════════════════════════════════════════════════

    MapStyle.stadiaAlidadeSmooth: MapStyleConfig(
      style: MapStyle.stadiaAlidadeSmooth,
      name: 'Alidade Smooth',
      description: 'Elegant light map with soft colors',
      urlTemplate:
          'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}{r}.png?api_key={apiKey}',
      attribution: stadiaAttribution,
      isDark: false,
      requiresApiKey: true,
      maxZoom: 20,
    ),

    MapStyle.stadiaAlidadeDark: MapStyleConfig(
      style: MapStyle.stadiaAlidadeDark,
      name: 'Alidade Smooth Dark',
      description: 'Beautiful dark map with muted colors',
      urlTemplate:
          'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png?api_key={apiKey}',
      attribution: stadiaAttribution,
      isDark: true,
      requiresApiKey: true,
      maxZoom: 20,
    ),

    MapStyle.stadiaOutdoors: MapStyleConfig(
      style: MapStyle.stadiaOutdoors,
      name: 'Outdoors',
      description: 'Topographic map with terrain details',
      urlTemplate:
          'https://tiles.stadiamaps.com/tiles/outdoors/{z}/{x}/{y}{r}.png?api_key={apiKey}',
      attribution: stadiaAttribution,
      isDark: false,
      requiresApiKey: true,
      maxZoom: 20,
    ),

    MapStyle.stadiaOsmBright: MapStyleConfig(
      style: MapStyle.stadiaOsmBright,
      name: 'OSM Bright',
      description: 'Classic OpenStreetMap style with vibrant colors',
      urlTemplate:
          'https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}{r}.png?api_key={apiKey}',
      attribution: stadiaAttribution,
      isDark: false,
      requiresApiKey: true,
      maxZoom: 20,
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // OpenStreetMap
    // FOR DEVELOPMENT ONLY - Strict usage policy
    // Do not use in production without reading their tile usage policy
    // ═══════════════════════════════════════════════════════════════════════

    MapStyle.osmStandard: MapStyleConfig(
      style: MapStyle.osmStandard,
      name: 'OpenStreetMap',
      description: 'Standard OSM tiles (development only)',
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      attribution: osmAttribution,
      isDark: false,
      maxZoom: 19,
      supportsRetina: false,
    ),
  };

  /// Get style config by enum.
  static MapStyleConfig getStyle(MapStyle style) => styles[style]!;

  /// Get default style for light theme (CARTO Positron).
  static MapStyleConfig get defaultLight => styles[MapStyle.cartoPositron]!;

  /// Get default style for dark theme (CARTO Dark Matter).
  static MapStyleConfig get defaultDark => styles[MapStyle.cartoDarkMatter]!;

  /// Get style based on theme brightness.
  static MapStyleConfig getStyleForBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? defaultDark : defaultLight;
  }

  /// Get all light styles.
  static List<MapStyleConfig> get lightStyles =>
      styles.values.where((s) => !s.isDark && !s.requiresApiKey).toList();

  /// Get all dark styles.
  static List<MapStyleConfig> get darkStyles =>
      styles.values.where((s) => s.isDark && !s.requiresApiKey).toList();

  /// Get all free styles (no API key required).
  static List<MapStyleConfig> get freeStyles =>
      styles.values.where((s) => !s.requiresApiKey).toList();

  /// Recommended styles for earthquake visualization.
  static List<MapStyleConfig> get earthquakeStyles => [
        styles[MapStyle.cartoDarkMatter]!,
        styles[MapStyle.cartoPositron]!,
        styles[MapStyle.cartoVoyager]!,
        styles[MapStyle.openFreeMapPositron]!,
        styles[MapStyle.openFreeMapLiberty]!,
      ];
}

/// Extension for easy style switching in TileLayer.
extension MapStyleConfigExtension on MapStyleConfig {
  /// Get URL template with API key placeholder replaced.
  String getUrlWithApiKey(String? apiKey) {
    if (requiresApiKey && apiKey != null) {
      return urlTemplate.replaceAll('{apiKey}', apiKey);
    }
    return urlTemplate.replaceAll('?api_key={apiKey}', '');
  }
}
