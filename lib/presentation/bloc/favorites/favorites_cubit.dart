import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/favorite_location.dart';
import '../../../data/services/favorites_service.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesService _favoritesService;

  FavoritesCubit({required FavoritesService favoritesService})
      : _favoritesService = favoritesService,
        super(const FavoritesState());

  void loadFavorites() {
    emit(state.copyWith(status: FavoritesStatus.loading));

    try {
      final favorites = _favoritesService.getFavorites();
      emit(state.copyWith(
        status: FavoritesStatus.loaded,
        favorites: favorites,
        predefinedLocations: FavoriteLocation.predefinedLocations,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FavoritesStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> addFavorite(FavoriteLocation location) async {
    try {
      await _favoritesService.addFavorite(location);
      final favorites = _favoritesService.getFavorites();
      emit(state.copyWith(favorites: favorites));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to add favorite: $e'));
    }
  }

  Future<void> removeFavorite(String id) async {
    try {
      await _favoritesService.removeFavorite(id);
      final favorites = _favoritesService.getFavorites();
      emit(state.copyWith(favorites: favorites));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to remove favorite: $e'));
    }
  }

  Future<void> toggleFavorite(FavoriteLocation location) async {
    if (state.isFavorite(location.id)) {
      await removeFavorite(location.id);
    } else {
      await addFavorite(location);
    }
  }

  void selectLocation(FavoriteLocation? location) {
    emit(state.copyWith(selectedLocation: location));
  }

  Future<void> addCustomLocation({
    required String name,
    String? country,
    required double latitude,
    required double longitude,
    double radiusKm = 500,
  }) async {
    final location = FavoriteLocation(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      country: country,
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      isPredefined: false,
    );

    await addFavorite(location);
  }

  Future<void> updateLocationRadius(String id, double radiusKm) async {
    final location = _favoritesService.getFavorite(id);
    if (location != null) {
      final updated = location.copyWith(radiusKm: radiusKm);
      await _favoritesService.updateFavorite(updated);
      final favorites = _favoritesService.getFavorites();
      emit(state.copyWith(favorites: favorites));
    }
  }
}
