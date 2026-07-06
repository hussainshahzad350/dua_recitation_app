import 'package:flutter/foundation.dart';

/// An "Important Duas" category, e.g. Morning, Sleep, Forgiveness.
///
/// Categories are loaded from `categories.json`. Titles are stored per-language
/// in the JSON so the category list respects the selected app language without
/// requiring separate localization files for content.
@immutable
class DuaCategory {
  const DuaCategory({
    required this.id,
    required this.titleEnglish,
    required this.titleUrdu,
    required this.icon,
  });

  /// Stable identifier used by [Dua.category] and routing.
  final String id;

  /// English display title.
  final String titleEnglish;

  /// Urdu display title.
  final String titleUrdu;

  /// A short icon key (mapped to a Material icon in the UI layer).
  final String icon;

  /// Resolves the localized title for the given [isUrdu] flag.
  String title({required bool isUrdu}) => isUrdu ? titleUrdu : titleEnglish;

  /// Builds a [DuaCategory] from a decoded JSON map.
  factory DuaCategory.fromJson(Map<String, dynamic> json) {
    return DuaCategory(
      id: json['id'] as String,
      titleEnglish: json['titleEnglish'] as String? ?? '',
      titleUrdu: json['titleUrdu'] as String? ?? '',
      icon: json['icon'] as String? ?? 'dua',
    );
  }
}
