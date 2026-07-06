import 'package:dua_companion/features/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  late List<Override> overrides;

  setUp(() async {
    overrides = await widgetTestOverrides();
  });

  testWidgets('shows prompt, then results as the query changes',
      (tester) async {
    await tester.pumpWidget(
      wrapForTest(overrides: overrides, child: const SearchScreen()),
    );
    await tester.pumpAndSettle();

    // Initial prompt.
    expect(find.text('Start typing to search duas.'), findsOneWidget);

    // Typing a matching query shows the dua.
    await tester.enterText(find.byType(TextField), 'glory');
    await tester.pumpAndSettle();
    expect(find.text('Glory is to Allah'), findsOneWidget);

    // A non-matching query shows the no-results state.
    await tester.enterText(find.byType(TextField), 'zzzzz');
    await tester.pumpAndSettle();
    expect(find.text('No duas found.'), findsOneWidget);
  });
}
