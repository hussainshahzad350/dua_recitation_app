import 'package:flutter/foundation.dart';

/// The scholarly reference/attribution for a [Dua].
///
/// Every dua in this app must carry a real reference. This model is displayed
/// in the Reference bottom sheet and is intentionally simple: it separates the
/// primary collection/book, the narration number, an authenticity grading, and
/// an optional full hadith text.
@immutable
class DuaReference {
  const DuaReference({
    required this.sourceBook,
    required this.hadithCollection,
    required this.hadithNumber,
    required this.authenticity,
    this.fullHadith,
  });

  /// The book the dua is compiled in, e.g. `Hisnul Muslim`.
  final String sourceBook;

  /// The primary hadith collection, e.g. `Sahih Muslim`.
  final String hadithCollection;

  /// The narration number within [hadithCollection], e.g. `591`.
  final String hadithNumber;

  /// Authenticity grading, e.g. `Sahih`, `Hasan`, `Qur'an`.
  final String authenticity;

  /// The full hadith/verse text, when available. May be `null`.
  final String? fullHadith;

  /// Builds a [DuaReference] from a decoded JSON map.
  factory DuaReference.fromJson(Map<String, dynamic> json) {
    return DuaReference(
      sourceBook: json['sourceBook'] as String? ?? '',
      hadithCollection: json['hadithCollection'] as String? ?? '',
      hadithNumber: json['hadithNumber']?.toString() ?? '',
      authenticity: json['authenticity'] as String? ?? '',
      fullHadith: json['fullHadith'] as String?,
    );
  }

  /// Serializes this reference back to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'sourceBook': sourceBook,
        'hadithCollection': hadithCollection,
        'hadithNumber': hadithNumber,
        'authenticity': authenticity,
        if (fullHadith != null) 'fullHadith': fullHadith,
      };
}
