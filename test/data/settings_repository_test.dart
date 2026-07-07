import 'package:dua_companion/data/models/app_settings.dart';
import 'package:dua_companion/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('load returns defaults when nothing stored', () async {
    final SettingsRepository repo = SettingsRepository(await mockStorage());
    final AppSettings s = repo.load();
    expect(s.languageCode, 'en');
    expect(s.themeMode, ThemeMode.system);
    expect(s.showTransliteration, isTrue);
    expect(s.isRtl, isFalse);
  });

  test('save then load round-trips all fields', () async {
    final SettingsRepository repo = SettingsRepository(await mockStorage());
    const AppSettings updated = AppSettings(
      languageCode: 'ur',
      themeMode: ThemeMode.dark,
      arabicFontSize: 40,
      translationFontSize: 20,
      showTransliteration: false,
    );

    await repo.save(updated);
    final AppSettings loaded = repo.load();

    expect(loaded, updated);
    expect(loaded.isRtl, isTrue);
    expect(loaded.themeMode, ThemeMode.dark);
    expect(loaded.arabicFontSize, 40);
  });
}
