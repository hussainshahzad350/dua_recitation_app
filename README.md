# Dua Companion

A lightweight, **offline-first** Flutter app to help you recite **authentic
duas after Salah** without needing to memorize them. It is deliberately narrow
in scope — no prayer times, Qibla, Quran reader, tasbeeh counter, accounts, ads,
or notifications. Just the best possible dua reading (and listening) experience,
with proper references.

## ⚠️ Content authenticity — please read

The bundled duas are compiled from **Hisnul Muslim (Fortress of the Muslim)** and
cross-referenced with Sahih al-Bukhari, Sahih Muslim, Sunan Abi Dawud, Jami'
at-Tirmidhi and Sunan an-Nasa'i. Every dua carries a reference (collection,
number and authenticity grading).

**This is a seed dataset provided for review. You must verify all Arabic text,
translations and references against the original sources before publishing the
app.** No content should be treated as final until a qualified reviewer has
confirmed it.

## Features

- Post-Salah adhkar for each of the five prayers (Fajr → Isha)
- "Important Duas" organized by category (Morning/Evening, Forgiveness,
  Protection, Anxiety, Hardship, Rizq, Debt, Sleep, Waking, Parents, Travel,
  Home, Mosque, Market, Food)
- Arabic + English + Urdu, with optional transliteration
- Reference bottom sheet (source book, collection, number, authenticity)
- Instant offline search across Arabic, translations, category and source
- Favorites (stored on-device)
- Light / dark themes, adjustable Arabic & translation font sizes
- English (LTR) and Urdu (RTL) with full right-to-left support
- Offline audio playback wired by convention (see [Audio](#audio))

## Architecture

Feature-based clean architecture with **Riverpod** for state and **JSON** for
content (no SQLite in v1). Persistence for favorites/language/theme uses
`SharedPreferences` behind a `StorageService`, so a future move to Hive/SQLite
would not touch the UI.

```
lib/
  core/         constants, theme, localization, services, widgets
  data/         models, repositories
  features/     splash, home, prayer_duas, important_duas, favorites,
                search, settings, reference
  shared/       Riverpod providers
  app.dart      MaterialApp (theme + locale)
  main.dart     entry point
assets/
  data/         duas.json, categories.json
  audio/        recitation files ({duaId}.mp3) — see below
```

## Audio

Audio is resolved **by convention**: a dua with id `x` plays `assets/audio/x.mp3`.
No recitation files are bundled yet, so the play button shows a friendly
"audio not available yet" message. To enable audio, drop correctly-named MP3
files into `assets/audio/` — no code change is required.

## Getting started

The Dart/Flutter source, content and tests are all included. Platform folders
(`android/`, `ios/`) are **not** committed; generate them once with:

```bash
flutter create . --platforms=android,ios
```

Then:

```bash
flutter pub get
flutter analyze
flutter test          # unit + widget tests
flutter run           # on a device or emulator
```

## Testing

- **Unit tests**: model parsing, dua repository (filter/search), favorites,
  settings, audio service, localization.
- **Widget tests**: dua card, home screen, search screen.

Tests use in-memory fakes (a `TestAssetBundle`, mocked `SharedPreferences`, and a
fake audio service) so they run fast and touch no plugins. See
`test/test_utils.dart`.

## Privacy & security

No accounts, no cloud, no analytics, no personal data collection, and no network
requests during normal use. Favorites and settings live only on the device.

## Roadmap (not implemented)

Additional reciters, downloadable audio packs, content updates, more languages,
daily reminders, notes/collections, and scholar commentary.
