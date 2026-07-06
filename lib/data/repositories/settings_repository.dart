import 'package:flutter/material.dart' show ThemeMode;

import '../../core/constants/app_constants.dart';
import '../../core/services/storage_service.dart';
import '../models/app_settings.dart';

/// Loads and persists [AppSettings] via [StorageService].
class SettingsRepository {
  SettingsRepository(this._storage);

  final StorageService _storage;

  /// Loads settings from storage, falling back to sensible defaults.
  AppSettings load() {
    return AppSettings(
      languageCode:
          _storage.getString(AppConstants.prefsLanguage) ?? 'en',
      themeMode: _themeModeFromString(
          _storage.getString(AppConstants.prefsThemeMode)),
      arabicFontSize: _storage.getDouble(AppConstants.prefsArabicFontSize) ??
          AppConstants.defaultArabicFontSize,
      translationFontSize:
          _storage.getDouble(AppConstants.prefsTranslationFontSize) ??
              AppConstants.defaultTranslationFontSize,
      showTransliteration:
          _storage.getBool(AppConstants.prefsShowTransliteration) ?? true,
    );
  }

  /// Persists all fields of [settings].
  Future<void> save(AppSettings settings) async {
    await _storage.setString(
        AppConstants.prefsLanguage, settings.languageCode);
    await _storage.setString(
        AppConstants.prefsThemeMode, _themeModeToString(settings.themeMode));
    await _storage.setDouble(
        AppConstants.prefsArabicFontSize, settings.arabicFontSize);
    await _storage.setDouble(AppConstants.prefsTranslationFontSize,
        settings.translationFontSize);
    await _storage.setBool(AppConstants.prefsShowTransliteration,
        settings.showTransliteration);
  }

  static ThemeMode _themeModeFromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
