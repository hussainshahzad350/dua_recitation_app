import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/audio_service.dart';
import '../core/services/storage_service.dart';
import '../data/models/app_settings.dart';
import '../data/models/dua.dart';
import '../data/models/dua_category.dart';
import '../data/repositories/dua_repository.dart';
import '../data/repositories/favorites_repository.dart';
import '../data/repositories/settings_repository.dart';

/// Provides the initialized [StorageService].
///
/// Overridden in `main.dart` after async initialization so the rest of the app
/// can depend on it synchronously.
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('storageServiceProvider must be overridden');
});

/// The dua content repository (loads JSON on demand).
final duaRepositoryProvider = Provider<DuaRepository>((ref) => DuaRepository());

/// Loads and parses the bundled dua content. Awaited by the splash screen.
final contentLoaderProvider = FutureProvider<void>((ref) async {
  await ref.watch(duaRepositoryProvider).ensureLoaded();
});

/// Favorites persistence.
final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepository(ref.watch(storageServiceProvider));
});

/// Settings persistence.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.watch(storageServiceProvider));
});

/// The offline audio service. Disposed with the provider container.
final audioServiceProvider = Provider<AudioService>((ref) {
  final AudioService service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});

// ---------------------------------------------------------------------------
// Favorites state
// ---------------------------------------------------------------------------

/// Holds the set of favorite dua ids and toggles them.
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier(this._repo) : super(_repo.load());

  final FavoritesRepository _repo;

  /// Toggles [id] and persists the change.
  Future<void> toggle(String id) async {
    state = await _repo.toggle(id);
  }

  /// Whether [id] is currently a favorite.
  bool isFavorite(String id) => state.contains(id);
}

/// The current set of favorite dua ids.
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier(ref.watch(favoritesRepositoryProvider));
});

// ---------------------------------------------------------------------------
// Settings state
// ---------------------------------------------------------------------------

/// Holds [AppSettings] and persists every change.
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier(this._repo) : super(_repo.load());

  final SettingsRepository _repo;

  Future<void> _update(AppSettings next) async {
    state = next;
    await _repo.save(next);
  }

  /// Sets the app language (`en` / `ur`).
  Future<void> setLanguage(String code) =>
      _update(state.copyWith(languageCode: code));

  /// Sets the theme mode.
  Future<void> setThemeMode(ThemeMode mode) =>
      _update(state.copyWith(themeMode: mode));

  /// Sets the Arabic font size.
  Future<void> setArabicFontSize(double size) =>
      _update(state.copyWith(arabicFontSize: size));

  /// Sets the translation font size.
  Future<void> setTranslationFontSize(double size) =>
      _update(state.copyWith(translationFontSize: size));

  /// Toggles whether transliteration is shown.
  Future<void> setShowTransliteration(bool value) =>
      _update(state.copyWith(showTransliteration: value));
}

/// The current user settings.
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref.watch(settingsRepositoryProvider));
});

// ---------------------------------------------------------------------------
// Content queries
// ---------------------------------------------------------------------------

/// All "Important Duas" categories.
final categoriesProvider = Provider<List<DuaCategory>>((ref) {
  return ref.watch(duaRepositoryProvider).categories;
});

/// Duas recited after a given prayer id.
final duasByPrayerProvider =
    Provider.family<List<Dua>, String>((ref, String prayerId) {
  return ref.watch(duaRepositoryProvider).byPrayer(prayerId);
});

/// Duas in a given category id.
final duasByCategoryProvider =
    Provider.family<List<Dua>, String>((ref, String categoryId) {
  return ref.watch(duaRepositoryProvider).byCategory(categoryId);
});

/// The user's favorite duas, resolved from content.
final favoriteDuasProvider = Provider<List<Dua>>((ref) {
  final Set<String> ids = ref.watch(favoritesProvider);
  return ref.watch(duaRepositoryProvider).byIds(ids);
});

// ---------------------------------------------------------------------------
// Search
// ---------------------------------------------------------------------------

/// The current search query text.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// The results for [searchQueryProvider], recomputed as the query changes.
final searchResultsProvider = Provider<List<Dua>>((ref) {
  final String query = ref.watch(searchQueryProvider);
  return ref.watch(duaRepositoryProvider).search(query);
});

// ---------------------------------------------------------------------------
// Audio playback state
// ---------------------------------------------------------------------------

/// Tracks which dua (if any) is currently playing.
///
/// Holds the playing dua's id, or `null` when nothing is playing. It listens to
/// the [AudioService] state stream to reset when playback completes or stops.
class AudioController extends StateNotifier<String?> {
  AudioController(this._service) : super(null) {
    _sub = _service.onStateChanged.listen((PlayerState playerState) {
      if (playerState == PlayerState.completed ||
          playerState == PlayerState.stopped) {
        state = null;
      }
    });
  }

  final AudioService _service;
  StreamSubscription<PlayerState>? _sub;

  /// Plays [dua]'s recitation. Returns `false` if audio is not bundled yet.
  Future<bool> play(Dua dua) async {
    try {
      await _service.play(dua.audioAsset);
      state = dua.id;
      return true;
    } on AudioUnavailableException {
      state = null;
      return false;
    }
  }

  /// Stops playback.
  Future<void> stop() async {
    await _service.stop();
    state = null;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// The currently playing dua id (or `null`).
final audioControllerProvider =
    StateNotifierProvider<AudioController, String?>((ref) {
  return AudioController(ref.watch(audioServiceProvider));
});
