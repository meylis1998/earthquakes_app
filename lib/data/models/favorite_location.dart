import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'favorite_location.g.dart';

@HiveType(typeId: 0)
class FavoriteLocation extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? country;

  @HiveField(3)
  final double latitude;

  @HiveField(4)
  final double longitude;

  @HiveField(5)
  final double radiusKm;

  @HiveField(6)
  final bool isPredefined;

  const FavoriteLocation({
    required this.id,
    required this.name,
    this.country,
    required this.latitude,
    required this.longitude,
    this.radiusKm = 500,
    this.isPredefined = false,
  });

  FavoriteLocation copyWith({
    String? id,
    String? name,
    String? country,
    double? latitude,
    double? longitude,
    double? radiusKm,
    bool? isPredefined,
  }) {
    return FavoriteLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusKm: radiusKm ?? this.radiusKm,
      isPredefined: isPredefined ?? this.isPredefined,
    );
  }

  @override
  List<Object?> get props => [id, name, country, latitude, longitude, radiusKm, isPredefined];

  /// Predefined Turkmenistan locations
  static const List<FavoriteLocation> turkmenistanCities = [
    FavoriteLocation(
      id: 'tm_ashgabat',
      name: 'Ashgabat',
      country: 'Turkmenistan',
      latitude: 37.9601,
      longitude: 58.3261,
      radiusKm: 300,
      isPredefined: true,
    ),
    FavoriteLocation(
      id: 'tm_turkmenbasy',
      name: 'Türkmenbaşy',
      country: 'Turkmenistan',
      latitude: 40.0633,
      longitude: 52.9694,
      radiusKm: 200,
      isPredefined: true,
    ),
    FavoriteLocation(
      id: 'tm_mary',
      name: 'Mary',
      country: 'Turkmenistan',
      latitude: 37.5936,
      longitude: 61.8303,
      radiusKm: 200,
      isPredefined: true,
    ),
    FavoriteLocation(
      id: 'tm_balkanabat',
      name: 'Balkanabat',
      country: 'Turkmenistan',
      latitude: 39.5107,
      longitude: 54.3671,
      radiusKm: 200,
      isPredefined: true,
    ),
    FavoriteLocation(
      id: 'tm_dashoguz',
      name: 'Daşoguz',
      country: 'Turkmenistan',
      latitude: 41.8363,
      longitude: 59.9666,
      radiusKm: 200,
      isPredefined: true,
    ),
    FavoriteLocation(
      id: 'tm_turkmenabat',
      name: 'Türkmenabat',
      country: 'Turkmenistan',
      latitude: 39.0733,
      longitude: 63.5786,
      radiusKm: 200,
      isPredefined: true,
    ),
  ];

  /// Entire Turkmenistan as a region
  static const FavoriteLocation turkmenistanRegion = FavoriteLocation(
    id: 'tm_region',
    name: 'Turkmenistan',
    country: 'Turkmenistan',
    latitude: 38.9697,
    longitude: 59.5563,
    radiusKm: 800,
    isPredefined: true,
  );

  /// All predefined locations
  static List<FavoriteLocation> get predefinedLocations => [
    turkmenistanRegion,
    ...turkmenistanCities,
  ];
}
