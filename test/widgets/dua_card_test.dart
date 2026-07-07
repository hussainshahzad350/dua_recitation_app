import 'package:dua_companion/core/widgets/dua_card.dart';
import 'package:dua_companion/data/models/dua.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  late List<Override> overrides;
  late Dua dua;

  setUp(() async {
    overrides = await widgetTestOverrides();
    dua = (await loadedTestRepository()).byId('d1')!;
  });

  testWidgets('renders Arabic, translations and actions', (tester) async {
    await tester.pumpWidget(
      wrapForTest(
        overrides: overrides,
        child: Scaffold(body: DuaCard(dua)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('سُبْحَانَ اللَّهِ'), findsOneWidget);
    expect(find.text('Glory is to Allah'), findsOneWidget);
    expect(find.text('اللہ پاک ہے'), findsOneWidget);
    // Repeat badge.
    expect(find.text('Repeat 33×'), findsOneWidget);
    // Action buttons.
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
    expect(find.byIcon(Icons.menu_book_rounded), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.share_rounded), findsOneWidget);
  });

  testWidgets('tapping favorite toggles the icon', (tester) async {
    await tester.pumpWidget(
      wrapForTest(
        overrides: overrides,
        child: Scaffold(body: DuaCard(dua)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('opens the reference sheet', (tester) async {
    await tester.pumpWidget(
      wrapForTest(
        overrides: overrides,
        child: Scaffold(body: DuaCard(dua)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu_book_rounded));
    await tester.pumpAndSettle();

    // Reference sheet shows the collection and number.
    expect(find.text('Sahih Muslim'), findsOneWidget);
    expect(find.text('597'), findsOneWidget);
  });
}
