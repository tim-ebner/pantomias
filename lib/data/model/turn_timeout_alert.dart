import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

abstract class TurnTimeoutAlert {
  Future<void> play();

  Future<void> dispose() async {}
}

class AudioVibrationTurnTimeoutAlert implements TurnTimeoutAlert {
  AudioVibrationTurnTimeoutAlert() : _audioPlayer = AudioPlayer();

  final AudioPlayer _audioPlayer;

  @override
  Future<void> play() async {
    await Future.wait([
      _audioPlayer.play(AssetSource('audio/time_up.wav')),
      _vibrate(),
    ]);
  }

  Future<void> _vibrate() async {
    if (!await Vibration.hasVibrator()) {
      return;
    }

    await Vibration.vibrate(duration: 700);
  }

  @override
  Future<void> dispose() {
    return _audioPlayer.dispose();
  }
}
