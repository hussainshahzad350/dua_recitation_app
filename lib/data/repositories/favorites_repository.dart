import '../../core/constants/app_constants.dart';
import '../../core/services/storage_service.dart';

/// Persists and mutates the set of favorite dua ids.
///
/// Favorites are stored as a simple string list in [StorageService] so they
/// survive restarts and work fully offline.
class FavoritesRepository {
  FavoritesRepository(this._storage);

  final StorageService _storage;

  /// Loads the current set of favorite ids from storage.
  Set<String> load() =>
      _storage.getStringList(AppConstants.prefsFavorites).toSet();

  /// Persists the given set of favorite [ids].
  Future<void> save(Set<String> ids) =>
      _storage.setStringList(AppConstants.prefsFavorites, ids.toList());

  /// Returns whether [id] is currently a favorite.
  bool isFavorite(String id) => load().contains(id);

  /// Toggles [id] in the favorites set and returns the updated set.
  Future<Set<String>> toggle(String id) async {
    final Set<String> ids = load();
    if (!ids.add(id)) {
      ids.remove(id);
    }
    await save(ids);
    return ids;
  }
}
