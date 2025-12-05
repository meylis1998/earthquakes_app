import 'package:equatable/equatable.dart';

import '../../../data/models/favorite_location.dart';

enum FavoritesStatus { initial, loading, loaded, error }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final List<FavoriteLocation> favorites;
  final List<FavoriteLocation> predefinedLocations;
  final FavoriteLocation? selectedLocation;
  final String? errorMessage;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const [],
    this.predefinedLocations = const [],
    this.selectedLocation,
    this.errorMessage,
  });

  /// Get all locations (predefined + user favorites)
  List<FavoriteLocation> get allLocations => [
    ...predefinedLocations,
    ...favorites.where((f) => !f.isPredefined),
  ];

  /// Check if a location is in user favorites
  bool isFavorite(String id) => favorites.any((f) => f.id == id);

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<FavoriteLocation>? favorites,
    List<FavoriteLocation>? predefinedLocations,
    FavoriteLocation? selectedLocation,
    String? errorMessage,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
      predefinedLocations: predefinedLocations ?? this.predefinedLocations,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    favorites,
    predefinedLocations,
    selectedLocation,
    errorMessage,
  ];
}
