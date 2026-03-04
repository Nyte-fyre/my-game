import 'package:flame_audio/flame_audio.dart';

class SoundManager {
  static Future<void> preloadAll() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      'game_over.wav',
      'game_start.wav',
      'hit.wav',
      'level.wav',
      'shoot.wav',
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
    FlameAudio.play('game_over.wav', volume: 0.8);
  }

  static void playGameStart() {
    FlameAudio.play('game_start.wav', volume: 0.8);
  }
}
