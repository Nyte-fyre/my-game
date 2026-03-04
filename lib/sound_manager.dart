import 'dart:math';
import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  static final List<String> _bgmTracks = [
    'bgm1.mp3',
    'bgm2.mp3',
    'bgm3.mp3',
    'bgm4.mp3',
  ];

  static final Random _random = Random();
  static String? _lastPlayed;

  static Future<void> preloadAll() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      'game_over.wav',
      'game_start.wav',
      'hit.wav',
      'level.wav',
      'shoot.wav',
      'bgm1.mp3',
      'bgm2.mp3',
      'bgm3.mp3',
      'bgm4.mp3',
    ]);
  }

  static void playShoot() {
    FlameAudio.play('shoot.wav', volume: 0.4);
  }

  static void playHit() {
    FlameAudio.play('hit.wav', volume: 0.7);
  }

  static void playLevelUp() {
    FlameAudio.play('level.wav', volume: 0.8);
  }

  static void playGameOver() {
    FlameAudio.bgm.stop();
    FlameAudio.play('game_over.wav', volume: 0.8);
  }

  static void playGameStart() {
    FlameAudio.play('game_start.wav', volume: 0.8);
  }

  static void playNextTrack() {
    // Pick a random track that isn't the last one played
    String next;
    do {
      next = _bgmTracks[_random.nextInt(_bgmTracks.length)];
    } while (next == _lastPlayed && _bgmTracks.length > 1);

    _lastPlayed = next;
    FlameAudio.bgm.play(next, volume: 0.5);
  }

  static void stopBgm() {
    FlameAudio.bgm.stop();
  }

  static void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  static void resumeBgm() {
    FlameAudio.bgm.resume();
  }
}
