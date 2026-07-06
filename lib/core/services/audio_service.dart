import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;

/// Thrown when a dua's recitation audio has not been bundled yet.
///
/// The audio UI catches this and shows a friendly "audio not available yet"
/// message rather than crashing, so recitation files can be added later with no
/// code change.
class AudioUnavailableException implements Exception {
  const AudioUnavailableException(this.assetKey);

  /// The full asset key that could not be found (e.g. `assets/audio/x.mp3`).
  final String assetKey;

  @override
  String toString() => 'AudioUnavailableException: $assetKey not found';
}

/// Plays offline recitation audio bundled with the app.
///
/// Audio is resolved by convention: a dua with id `x` maps to
/// `assets/audio/x.mp3`. The service verifies the asset exists before playing
/// and surfaces a typed [AudioUnavailableException] when it does not.
class AudioService {
  AudioService({AudioPlayer? player, AssetBundle? bundle})
      : _player = player ?? AudioPlayer(),
        _bundle = bundle ?? rootBundle;

  final AudioPlayer _player;
  final AssetBundle _bundle;

  /// Emits the player's state changes (playing, paused, stopped, completed).
  Stream<PlayerState> get onStateChanged => _player.onPlayerStateChanged;

  /// Whether the bundled asset for [assetKey] exists (e.g. can be played).
  ///
  /// [assetKey] is the full key including the `assets/` prefix.
  Future<bool> exists(String assetKey) async {
    try {
      await _bundle.load(assetKey);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Plays the audio at [assetKey] (full key including `assets/`).
  ///
  /// Throws [AudioUnavailableException] if the file is not bundled.
  Future<void> play(String assetKey) async {
    if (!await exists(assetKey)) {
      throw AudioUnavailableException(assetKey);
    }
    // AssetSource paths are relative to the `assets/` folder.
    final String sourcePath = assetKey.startsWith('assets/')
        ? assetKey.substring('assets/'.length)
        : assetKey;
    await _player.stop();
    await _player.play(AssetSource(sourcePath));
  }

  /// Stops any current playback.
  Future<void> stop() => _player.stop();

  /// Releases the underlying player.
  Future<void> dispose() => _player.dispose();
}
