import 'package:dua_companion/core/services/storage_service.dart';
import 'package:dua_companion/data/repositories/favorites_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('starts empty', () async {
    final FavoritesRepository repo =
        FavoritesRepository(await mockStorage());
    expect(repo.load(), isEmpty);
  });

  test('toggle adds then removes an id', () async {
    final FavoritesRepository repo =
        FavoritesRepository(await mockStorage());

    Set<String> ids = await repo.toggle('d1');
    expect(ids, <String>{'d1'});
    expect(repo.isFavorite('d1'), isTrue);

    ids = await repo.toggle('d1');
    expect(ids, isEmpty);
    expect(repo.isFavorite('d1'), isFalse);
  });

  test('persists across new repository instances', () async {
    final StorageService storage = await mockStorage();

    final FavoritesRepository first = FavoritesRepository(storage);
    await first.toggle('d2');

    // A new repository over the same storage sees the saved favorite.
    final FavoritesRepository second = FavoritesRepository(storage);
    expect(second.isFavorite('d2'), isTrue);
  });
}
