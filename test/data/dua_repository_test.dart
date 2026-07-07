import 'package:dua_companion/data/models/dua.dart';
import 'package:dua_companion/data/repositories/dua_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  late DuaRepository repo;

  setUp(() async {
    repo = await loadedTestRepository();
  });

  test('loads all duas and categories', () {
    expect(repo.all.length, 2);
    expect(repo.categories.length, 2);
  });

  test('byPrayer filters by prayer id', () {
    expect(repo.byPrayer('fajr').map((Dua d) => d.id), <String>['d1']);
    expect(repo.byPrayer('isha'), isEmpty);
  });

  test('byCategory filters by category id', () {
    expect(repo.byCategory('sleep').map((Dua d) => d.id), <String>['d2']);
    expect(repo.byCategory('food'), isEmpty);
  });

  test('byId returns matching dua or null', () {
    expect(repo.byId('d2')?.title, 'Sleep');
    expect(repo.byId('missing'), isNull);
  });

  test('byIds preserves content order', () {
    final List<Dua> result = repo.byIds(<String>{'d2', 'd1'});
    expect(result.map((Dua d) => d.id), <String>['d1', 'd2']);
  });

  group('search', () {
    test('empty query returns nothing', () {
      expect(repo.search(''), isEmpty);
      expect(repo.search('   '), isEmpty);
    });

    test('matches English translation case-insensitively', () {
      expect(repo.search('GLORY').map((Dua d) => d.id), <String>['d1']);
    });

    test('matches Arabic text', () {
      expect(repo.search('سُبْحَانَ').map((Dua d) => d.id), <String>['d1']);
    });

    test('matches keywords and category', () {
      expect(repo.search('night').map((Dua d) => d.id), <String>['d2']);
      expect(repo.search('sleep').map((Dua d) => d.id), <String>['d2']);
    });

    test('matches source collection', () {
      expect(repo.search('Bukhari').map((Dua d) => d.id), <String>['d2']);
    });

    test('no match returns empty', () {
      expect(repo.search('zzzzz'), isEmpty);
    });
  });
}
