import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

/// Builds the light and dark [ThemeData] for the app.
///
/// The palette is deliberately calm and minimal: a teal/green seed evoking a
/// serene, mosque-like tone, generous spacing, and soft card elevation. Both
/// light and dark variants are derived from the same seed so they stay
/// consistent.
abstract final class AppTheme {
  /// Seed color used to generate the Material 3 color schemes.
  static const Color _seed = Color(0xFF16745F);

  /// The light theme.
  static ThemeData get light => _build(Brightness.light);

  /// The dark theme.
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );

    final ThemeData base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        minVerticalPadding: 12,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
