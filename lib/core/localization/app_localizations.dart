import 'package:flutter/material.dart';

import 'app_strings.dart';

/// Provides localized UI strings for the supported languages.
///
/// A deliberately lightweight, dependency-free localization layer: strings live
/// in [enStrings] / [urStrings] maps (see `app_strings.dart`) and are looked up
/// by key. This avoids code generation while still keeping every UI string out
/// of the widget tree.
class AppLocalizations {
  AppLocalizations(this.locale)
      : _strings = locale.languageCode == 'ur' ? urStrings : enStrings;

  /// The active locale.
  final Locale locale;

  final Map<String, String> _strings;

  /// The list of locales this app supports.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// The delegate wired into `MaterialApp.localizationsDelegates`.
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Retrieves the [AppLocalizations] for the given [context].
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// Whether the current language is Urdu (and therefore right-to-left).
  bool get isUrdu => locale.languageCode == 'ur';

  /// Looks up a string by [key], falling back to English then the key itself.
  String t(String key) => _strings[key] ?? enStrings[key] ?? key;

  /// Looks up [key] and substitutes `{name}` placeholders from [args].
  String tf(String key, Map<String, String> args) {
    var result = t(key);
    args.forEach((String name, String value) {
      result = result.replaceAll('{$name}', value);
    });
    return result;
  }

  /// Localized label for a prayer given its stable id (e.g. `fajr`).
  String prayer(String id) => t('prayer_$id');

  /// Localized "Duas after {prayer}" title.
  String prayerDuasTitle(String prayerId) =>
      tf('prayer_duas_title', <String, String>{'prayer': prayer(prayerId)});

  /// Localized "repeat N times" label, e.g. "Repeat 3×".
  String repeat(int count) => '${t('repeat')} $count×';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
