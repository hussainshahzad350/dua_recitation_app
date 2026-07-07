import 'dart:convert';

import 'package:audioplayers/audioplayers.dart' show PlayerState;
import 'package:dua_companion/core/localization/app_localizations.dart';
import 'package:dua_companion/core/services/audio_service.dart';
import 'package:dua_companion/core/services/storage_service.dart';
import 'package:dua_companion/data/repositories/dua_repository.dart';
import 'package:dua_companion/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A tiny in-memory [AssetBundle] for tests, backed by a key -> string map.
class TestAssetBundle extends CachingAssetBundle {
  TestAssetBundle(this.files);

  final Map<String, String> files;

  @override
  Future<ByteData> load(String key) async {
    final String? content = files[key];
    if (content == null) {
      throw FlutterError('Asset not found: $key');
    }
    final Uint8List bytes = Uint8List.fromList(utf8.encode(content));
    return ByteData.view(bytes.buffer);
  }
}

/// A small, deterministic dua dataset used across tests.
const String testDuasJson = '''
[
  {
    "id": "d1",
    "title": "Tasbeeh",
    "arabic": "سُبْحَانَ اللَّهِ",
    "translationEnglish": "Glory is to Allah",
    "translationUrdu": "اللہ پاک ہے",
    "transliteration": "SubhanAllah",
    "repeat": 33,
    "prayers": ["fajr", "dhuhr"],
    "keywords": ["tasbeeh", "glory"],
    "tags": ["post-salah"],
    "reference": {
      "sourceBook": "Hisnul Muslim",
      "hadithCollection": "Sahih Muslim",
      "hadithNumber": "597",
      "authenticity": "Sahih"
    }
  },
  {
    "id": "d2",
    "title": "Sleep",
    "arabic": "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
    "translationEnglish": "In Your name O Allah I die and live",
    "translationUrdu": "اے اللہ تیرے نام سے",
    "transliteration": "Bismika Allahumma amutu wa ahya",
    "category": "sleep",
    "prayers": [],
    "keywords": ["sleep", "night"],
    "tags": ["sleep"],
    "reference": {
      "sourceBook": "Hisnul Muslim",
      "hadithCollection": "Sahih al-Bukhari",
      "hadithNumber": "6324",
      "authenticity": "Sahih"
    }
  }
]
''';

const String testCategoriesJson = '''
[
  { "id": "sleep", "titleEnglish": "Sleep", "titleUrdu": "نیند", "icon": "sleep" },
  { "id": "food", "titleEnglish": "Food", "titleUrdu": "کھانا", "icon": "food" }
]
''';

/// The asset bundle used by tests, wired to the constant paths.
TestAssetBundle testBundle() => TestAssetBundle(<String, String>{
      'assets/data/duas.json': testDuasJson,
      'assets/data/categories.json': testCategoriesJson,
      'assets/audio/d1.mp3': 'FAKE_AUDIO_BYTES',
    });

/// Builds a [DuaRepository] loaded from [testBundle].
Future<DuaRepository> loadedTestRepository() async {
  final DuaRepository repo = DuaRepository(bundle: testBundle());
  await repo.ensureLoaded();
  return repo;
}

/// Creates a [StorageService] backed by mocked SharedPreferences.
Future<StorageService> mockStorage(
    [Map<String, Object> initial = const <String, Object>{}]) async {
  SharedPreferences.setMockInitialValues(initial);
  return StorageService.create();
}

/// A no-op [AudioService] for widget tests that never touches the audio plugin.
class FakeAudioService implements AudioService {
  @override
  Stream<PlayerState> get onStateChanged => const Stream<PlayerState>.empty();

  @override
  Future<bool> exists(String assetKey) async => true;

  @override
  Future<void> play(String assetKey) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {}
}

/// Common provider overrides for widget tests: mocked storage, a preloaded
/// content repository, and a fake audio service (no plugin access).
Future<List<Override>> widgetTestOverrides() async {
  final StorageService storage = await mockStorage();
  final DuaRepository repo = await loadedTestRepository();
  return <Override>[
    storageServiceProvider.overrideWithValue(storage),
    duaRepositoryProvider.overrideWithValue(repo),
    audioServiceProvider.overrideWithValue(FakeAudioService()),
  ];
}

/// Wraps [child] in a localized [MaterialApp] with the given provider
/// [overrides], for widget tests.
Widget wrapForTest({
  required Widget child,
  required List<Override> overrides,
  Locale locale = const Locale('en'),
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    ),
  );
}
