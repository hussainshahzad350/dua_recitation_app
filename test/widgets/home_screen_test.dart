import 'package:dua_companion/features/home/home_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  late List<Override> overrides;

  setUp(() async {
    overrides = await widgetTestOverrides();
  });

  testWidgets('shows all prayers and explore entries', (tester) async {
    // Use a tall viewport so every list item is laid out at once (the lazy
    // ListView would otherwise not build entries below the fold).
    tester.view.physicalSize = const Size(1000, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      wrapForTest(overrides: overrides, child: const HomeScreen()),
    );
    await tester.pumpAndSettle();

    for (final String prayer in <String>[
      'Fajr',
      'Dhuhr',
      'Asr',
      'Maghrib',
      'Isha',
    ]) {
      expect(find.text(prayer), findsOneWidget);
    }
    expect(find.text('Important Duas'), findsOneWidget);
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('tapping a prayer opens its duas', (tester) async {
    await tester.pumpWidget(
      wrapForTest(overrides: overrides, child: const HomeScreen()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Fajr'));
    await tester.pumpAndSettle();

    expect(find.text('Duas after Fajr'), findsOneWidget);
    expect(find.text('Glory is to Allah'), findsOneWidget);
  });
}
