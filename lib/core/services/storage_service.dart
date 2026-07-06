import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around [SharedPreferences] used for the only three things the
/// app persists: favorites, language and theme (plus display preferences).
///
/// Keeping persistence behind this interface means a future migration to Hive
/// or SQLite would not touch the repositories or UI.
class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  /// Creates a [StorageService] backed by the platform preferences store.
  static Future<StorageService> create() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  /// Reads a string list (used for favorite ids).
  List<String> getStringList(String key) => _prefs.getStringList(key) ?? const [];

  /// Persists a string list.
  Future<void> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  /// Reads a string value, or `null` if unset.
  String? getString(String key) => _prefs.getString(key);

  /// Persists a string value.
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  /// Reads a double value, or `null` if unset.
  double? getDouble(String key) => _prefs.getDouble(key);

  /// Persists a double value.
  Future<void> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  /// Reads a bool value, or `null` if unset.
  bool? getBool(String key) => _prefs.getBool(key);

  /// Persists a bool value.
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);
}
