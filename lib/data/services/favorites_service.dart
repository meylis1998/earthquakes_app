import 'package:hive_flutter/hive_flutter.dart';

import '../models/favorite_location.dart';

class FavoritesService {
  static const String _boxName = 'favorites';

  late Box<FavoriteLocation> _box;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FavoriteLocationAdapter());
    }

    _box = await Hive.openBox<FavoriteLocation>(_boxName);
    _initialized = true;
  }

  List<FavoriteLocation> getFavorites() {
    if (!_initialized) return [];
    return _box.values.toList();
  }

  Future<void> addFavorite(FavoriteLocation location) async {
    if (!_initialized) return;
    await _box.put(location.id, location);
  }

  Future<void> removeFavorite(String id) async {
    if (!_initialized) return;
    await _box.delete(id);
  }

  Future<void> updateFavorite(FavoriteLocation location) async {
    if (!_initialized) return;
    await _box.put(location.id, location);
  }

  bool isFavorite(String id) {
    if (!_initialized) return false;
    return _box.containsKey(id);
  }

  FavoriteLocation? getFavorite(String id) {
    if (!_initialized) return null;
    return _box.get(id);
  }

  Future<void> clearAll() async {
    if (!_initialized) return;
    await _box.clear();
  }
}
