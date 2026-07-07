import 'package:dua_companion/core/localization/app_localizations.dart';
import 'package:flutter/material.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';

void main() {
  final AppLocalizations en = AppLocalizations(const Locale('en'));
  final AppLocalizations ur = AppLocalizations(const Locale('ur'));

  test('resolves English and Urdu strings', () {
    expect(en.t('favorites'), 'Favorites');
    expect(ur.t('favorites'), 'پسندیدہ');
  });

  test('isUrdu reflects locale', () {
    expect(en.isUrdu, isFalse);
    expect(ur.isUrdu, isTrue);
  });

  test('unknown key falls back to the key itself', () {
    expect(en.t('__missing__'), '__missing__');
  });

  test('prayer() resolves localized prayer names', () {
    expect(en.prayer('maghrib'), 'Maghrib');
    expect(ur.prayer('maghrib'), 'مغرب');
  });

  test('tf substitutes placeholders', () {
    expect(en.prayerDuasTitle('fajr'), 'Duas after Fajr');
  });

  test('repeat() formats a count', () {
    expect(en.repeat(3), 'Repeat 3×');
  });
}
