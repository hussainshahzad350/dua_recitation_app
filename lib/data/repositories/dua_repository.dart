import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../../core/constants/app_constants.dart';
import '../models/dua.dart';
import '../models/dua_category.dart';

/// Loads and queries the bundled dua content.
///
/// Content is parsed once from JSON and cached in memory. All queries are
/// synchronous against the in-memory lists, keeping search and filtering fast
/// and fully offline. This is intentionally the only place that knows content
/// comes from JSON, so a future move to Hive/SQLite would not affect callers.
class DuaRepository {
  DuaRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  List<Dua> _duas = const <Dua>[];
  List<DuaCategory> _categories = const <DuaCategory>[];
  bool _loaded = false;

  /// Loads and parses the JSON content if it has not been loaded yet.
  Future<void> ensureLoaded() async {
    if (_loaded) return;
    _duas = await _loadDuas();
    _categories = await _loadCategories();
    _loaded = true;
  }

  Future<List<Dua>> _loadDuas() async {
    final String raw = await _bundle.loadString(AppConstants.duasAsset);
    final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
    return decoded
        .map((dynamic e) => Dua.fromJson((e as Map).cast<String, dynamic>()))
        .toList(growable: false);
  }

  Future<List<DuaCategory>> _loadCategories() async {
    final String raw = await _bundle.loadString(AppConstants.categoriesAsset);
    final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
    return decoded
        .map((dynamic e) =>
            DuaCategory.fromJson((e as Map).cast<String, dynamic>()))
        .toList(growable: false);
  }

  /// All duas (unfiltered).
  List<Dua> get all => _duas;

  /// All categories.
  List<DuaCategory> get categories => _categories;

  /// Duas recited after the given [prayerId].
  List<Dua> byPrayer(String prayerId) =>
      _duas.where((Dua d) => d.belongsToPrayer(prayerId)).toList();

  /// Duas in the given [categoryId].
  List<Dua> byCategory(String categoryId) =>
      _duas.where((Dua d) => d.category == categoryId).toList();

  /// Finds a dua by [id], or `null` if none matches.
  Dua? byId(String id) {
    for (final Dua d in _duas) {
      if (d.id == id) return d;
    }
    return null;
  }

  /// Returns the duas whose ids are in [ids], preserving content order.
  List<Dua> byIds(Set<String> ids) =>
      _duas.where((Dua d) => ids.contains(d.id)).toList();

  /// Case-insensitive offline search across Arabic, translations,
  /// transliteration, title, keywords, tags, category and source.
  ///
  /// An empty [query] returns an empty list (the UI shows a prompt instead).
  List<Dua> search(String query) {
    final String q = query.trim().toLowerCase();
    if (q.isEmpty) return const <Dua>[];
    return _duas.where((Dua d) => _matches(d, q)).toList();
  }

  bool _matches(Dua d, String q) {
    bool has(String? s) => s != null && s.toLowerCase().contains(q);
    return has(d.title) ||
        has(d.arabic) ||
        has(d.translationEnglish) ||
        has(d.translationUrdu) ||
        has(d.transliteration) ||
        has(d.category) ||
        has(d.reference.hadithCollection) ||
        has(d.reference.sourceBook) ||
        d.keywords.any((String k) => k.toLowerCase().contains(q)) ||
        d.tags.any((String t) => t.toLowerCase().contains(q));
  }
}
