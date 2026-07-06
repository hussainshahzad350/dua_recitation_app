import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;

import '../../core/constants/app_constants.dart';

/// User-configurable display and language preferences.
///
/// Immutable value object; use [copyWith] to derive a modified instance.
@immutable
class AppSettings {
  const AppSettings({
    this.languageCode = 'en',
    this.themeMode = ThemeMode.system,
    this.arabicFontSize = AppConstants.defaultArabicFontSize,
    this.translationFontSize = AppConstants.defaultTranslationFontSize,
    this.showTransliteration = true,
  });

  /// Selected language: `en` or `ur`.
  final String languageCode;

  /// Selected theme mode.
  final ThemeMode themeMode;

  /// Arabic text size in logical pixels.
  final double arabicFontSize;

  /// Translation text size in logical pixels.
  final double translationFontSize;

  /// Whether transliteration is shown on dua cards.
  final bool showTransliteration;

  /// Whether the current language is right-to-left.
  bool get isRtl => languageCode == 'ur';

  /// Returns a copy with the given fields replaced.
  AppSettings copyWith({
    String? languageCode,
    ThemeMode? themeMode,
    double? arabicFontSize,
    double? translationFontSize,
    bool? showTransliteration,
  }) {
    return AppSettings(
      languageCode: languageCode ?? this.languageCode,
      themeMode: themeMode ?? this.themeMode,
      arabicFontSize: arabicFontSize ?? this.arabicFontSize,
      translationFontSize: translationFontSize ?? this.translationFontSize,
      showTransliteration: showTransliteration ?? this.showTransliteration,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.languageCode == languageCode &&
      other.themeMode == themeMode &&
      other.arabicFontSize == arabicFontSize &&
      other.translationFontSize == translationFontSize &&
      other.showTransliteration == showTransliteration;

  @override
  int get hashCode => Object.hash(languageCode, themeMode, arabicFontSize,
      translationFontSize, showTransliteration);
}
