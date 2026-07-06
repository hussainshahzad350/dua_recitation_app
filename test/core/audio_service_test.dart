import 'package:dua_companion/core/services/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('exists returns true for a bundled asset', () async {
    final AudioService service = AudioService(bundle: testBundle());
    expect(await service.exists('assets/audio/d1.mp3'), isTrue);
  });

  test('exists returns false for a missing asset', () async {
    final AudioService service = AudioService(bundle: testBundle());
    expect(await service.exists('assets/audio/nope.mp3'), isFalse);
  });

  test('play throws AudioUnavailableException when audio is missing', () async {
    final AudioService service = AudioService(bundle: testBundle());
    expect(
      () => service.play('assets/audio/nope.mp3'),
      throwsA(isA<AudioUnavailableException>()),
    );
  });
}
