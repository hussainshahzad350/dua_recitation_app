import 'dart:convert';

import 'package:dua_companion/data/models/dua.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dua.fromJson', () {
    final Map<String, dynamic> json = <String, dynamic>{
      'id': 'post_salah_tasbeeh',
      'title': 'Tasbeeh',
      'arabic': 'سُبْحَانَ اللَّهِ',
      'translationEnglish': 'Glory is to Allah',
      'translationUrdu': 'اللہ پاک ہے',
      'transliteration': 'SubhanAllah',
      'repeat': 33,
      'prayers': <String>['fajr', 'dhuhr'],
      'keywords': <String>['tasbeeh'],
      'tags': <String>['post-salah'],
      'reference': <String, dynamic>{
        'sourceBook': 'Hisnul Muslim',
        'hadithCollection': 'Sahih Muslim',
        'hadithNumber': '597',
        'authenticity': 'Sahih',
      },
    };

    test('parses all fields', () {
      final Dua dua = Dua.fromJson(json);
      expect(dua.id, 'post_salah_tasbeeh');
      expect(dua.arabic, 'سُبْحَانَ اللَّهِ');
      expect(dua.transliteration, 'SubhanAllah');
      expect(dua.repeat, 33);
      expect(dua.prayers, <String>['fajr', 'dhuhr']);
      expect(dua.reference.hadithNumber, '597');
      expect(dua.reference.authenticity, 'Sahih');
    });

    test('derives audio asset from id', () {
      final Dua dua = Dua.fromJson(json);
      expect(dua.audioAsset, 'assets/audio/post_salah_tasbeeh.mp3');
    });

    test('belongsToPrayer reflects prayers list', () {
      final Dua dua = Dua.fromJson(json);
      expect(dua.belongsToPrayer('fajr'), isTrue);
      expect(dua.belongsToPrayer('isha'), isFalse);
    });

    test('tolerates missing optional fields', () {
      final Dua dua = Dua.fromJson(<String, dynamic>{
        'id': 'x',
        'arabic': 'ا',
        'reference': <String, dynamic>{},
      });
      expect(dua.transliteration, isNull);
      expect(dua.category, isNull);
      expect(dua.prayers, isEmpty);
      expect(dua.keywords, isEmpty);
    });

    test('round-trips through JSON', () {
      final Dua dua = Dua.fromJson(json);
      final Dua again =
          Dua.fromJson(jsonDecode(jsonEncode(dua.toJson())) as Map<String, dynamic>);
      expect(again, dua); // equality is by id
      expect(again.arabic, dua.arabic);
      expect(again.repeat, dua.repeat);
    });
  });
}
