/// App-wide constants that do not belong to a single feature.
///
/// Keeping these in one place avoids magic numbers and duplicated strings
/// scattered across the UI.
abstract final class AppConstants {
  /// Display name of the application.
  static const String appName = 'Dua Companion';

  // ---- Asset paths -------------------------------------------------------

  /// Bundled JSON file containing all duas.
  static const String duasAsset = 'assets/data/duas.json';

  /// Bundled JSON file containing the "Important Duas" categories.
  static const String categoriesAsset = 'assets/data/categories.json';

  /// Directory that holds recitation audio, resolved by `{duaId}.mp3`.
  static const String audioDir = 'assets/audio';

  // ---- SharedPreferences keys -------------------------------------------

  /// Stored set of favorite dua ids.
  static const String prefsFavorites = 'favorites';

  /// Stored language code (`en` / `ur`).
  static const String prefsLanguage = 'language';

  /// Stored theme mode (`system` / `light` / `dark`).
  static const String prefsThemeMode = 'theme_mode';

  /// Stored Arabic font size (logical pixels).
  static const String prefsArabicFontSize = 'arabic_font_size';

  /// Stored translation font size (logical pixels).
  static const String prefsTranslationFontSize = 'translation_font_size';

  /// Stored flag for whether transliteration is shown.
  static const String prefsShowTransliteration = 'show_transliteration';

  // ---- Font size bounds --------------------------------------------------

  static const double minArabicFontSize = 22;
  static const double defaultArabicFontSize = 30;
  static const double maxArabicFontSize = 48;

  static const double minTranslationFontSize = 12;
  static const double defaultTranslationFontSize = 16;
  static const double maxTranslationFontSize = 24;

  // ---- Layout ------------------------------------------------------------

  static const double screenPadding = 16;
  static const double cardSpacing = 12;
  static const double cardRadius = 16;
}
