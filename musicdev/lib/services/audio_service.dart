import 'package:just_audio/just_audio.dart';

class AudioService {
  // One player per sound
  final Map<String, AudioPlayer> _players = {};

  // All available sounds mapped to their asset paths
  // You'll add actual audio files to assets/sounds/ folder
  static const Map<String, String> soundAssets = {
    'Rain': 'assets/sounds/rain.mp3',
    'Lo-Fi Music': 'assets/sounds/lofi.mp3',
    'White Noise': 'assets/sounds/white_noise.mp3',
    'Forest': 'assets/sounds/forest.mp3',
    'Ocean Waves': 'assets/sounds/ocean.mp3',
    'Café Ambience': 'assets/sounds/cafe.mp3',
  };

  Future<void> playSound(String name) async {
    if (!soundAssets.containsKey(name)) return;

    // Create a player for this sound if it doesn't exist
    _players[name] ??= AudioPlayer();

    final player = _players[name]!;
    await player.setAsset(soundAssets[name]!);
    await player.setLoopMode(LoopMode.one); // loop continuously
    await player.play();
  }

  Future<void> stopSound(String name) async {
    await _players[name]?.stop();
  }

  Future<void> setVolume(String name, double volume) async {
    await _players[name]?.setVolume(volume);
  }

  Future<void> stopAll() async {
    for (final player in _players.values) {
      await player.stop();
    }
  }

  Future<void> dispose() async {
    for (final player in _players.values) {
      await player.dispose();
    }
    _players.clear();
  }
}