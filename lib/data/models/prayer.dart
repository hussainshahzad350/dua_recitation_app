/// The five daily obligatory prayers (Salah).
///
/// The [id] is the stable identifier used in the dua JSON (`prayers` array)
/// and for routing/lookups. The display name is resolved through localization
/// so it is never hardcoded in the UI.
enum Prayer {
  fajr('fajr'),
  dhuhr('dhuhr'),
  asr('asr'),
  maghrib('maghrib'),
  isha('isha');

  const Prayer(this.id);

  /// Stable identifier used in JSON and routing (e.g. `"fajr"`).
  final String id;

  /// Resolves a [Prayer] from its [id], or `null` if it does not match.
  static Prayer? fromId(String id) {
    for (final prayer in Prayer.values) {
      if (prayer.id == id) return prayer;
    }
    return null;
  }
}
