import 'package:flutter/foundation.dart';

import 'dua_reference.dart';

/// A single supplication (dua).
///
/// This is the central content model of the app. Instances are immutable and
/// parsed from the bundled JSON. Note that [isFavorite] is **not** part of the
/// stored content — favorite state is owned by the favorites repository and is
/// derived at the UI layer, so the JSON never needs to change when a user
/// favorites a dua.
@immutable
class Dua {
  const Dua({
    required this.id,
    required this.title,
    required this.arabic,
    required this.translationEnglish,
    required this.translationUrdu,
    required this.reference,
    this.category,
    this.prayers = const <String>[],
    this.transliteration,
    this.repeat,
    this.keywords = const <String>[],
    this.tags = const <String>[],
  });

  /// Stable unique identifier, also used to resolve the audio asset path
  /// (`assets/audio/{id}.mp3`).
  final String id;

  /// Short human-readable title, e.g. `Tasbeeh after Salah`.
  final String title;

  /// The original Arabic text. Preserved exactly as sourced.
  final String arabic;

  /// English translation of [arabic].
  final String translationEnglish;

  /// Urdu translation of [arabic].
  final String translationUrdu;

  /// Optional Latin-script transliteration of [arabic].
  final String? transliteration;

  /// The scholarly reference for this dua. Required for every dua.
  final DuaReference reference;

  /// Optional "Important Duas" category id (see `categories.json`).
  /// `null` for duas that are only post-Salah adhkar.
  final String? category;

  /// The prayer ids this dua is recited after. Empty means it is not a
  /// post-Salah dua (it belongs to a category instead).
  final List<String> prayers;

  /// Optional recommended repetition count, e.g. `3` or `33`.
  final int? repeat;

  /// Search keywords (typically English) to improve findability.
  final List<String> keywords;

  /// Free-form tags for grouping/filtering.
  final List<String> tags;

  /// The bundled audio asset path derived from [id].
  ///
  /// The [AudioService] tolerates the file being absent, so this can safely
  /// point at an asset that has not been added yet.
  String get audioAsset => 'assets/audio/$id.mp3';

  /// Whether this dua is recited after the given [prayerId].
  bool belongsToPrayer(String prayerId) => prayers.contains(prayerId);

  /// Builds a [Dua] from a decoded JSON map.
  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      arabic: json['arabic'] as String? ?? '',
      translationEnglish: json['translationEnglish'] as String? ?? '',
      translationUrdu: json['translationUrdu'] as String? ?? '',
      transliteration: json['transliteration'] as String?,
      reference: DuaReference.fromJson(
        (json['reference'] as Map?)?.cast<String, dynamic>() ??
            const <String, dynamic>{},
      ),
      category: json['category'] as String?,
      prayers: _stringList(json['prayers']),
      repeat: (json['repeat'] as num?)?.toInt(),
      keywords: _stringList(json['keywords']),
      tags: _stringList(json['tags']),
    );
  }

  /// Serializes this dua back to a JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'arabic': arabic,
        'translationEnglish': translationEnglish,
        'translationUrdu': translationUrdu,
        if (transliteration != null) 'transliteration': transliteration,
        'reference': reference.toJson(),
        if (category != null) 'category': category,
        'prayers': prayers,
        if (repeat != null) 'repeat': repeat,
        'keywords': keywords,
        'tags': tags,
      };

  static List<String> _stringList(Object? value) {
    if (value is List) {
      return value.map((Object? e) => e.toString()).toList(growable: false);
    }
    return const <String>[];
  }

  @override
  bool operator ==(Object other) =>
      other is Dua && other.runtimeType == runtimeType && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
