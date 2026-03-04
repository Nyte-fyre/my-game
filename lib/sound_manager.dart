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
  static bool _isStartingTrack = false;

  // Cooldown trackers
  static double _shootCooldown = 0;
  static double _hitCooldown = 0;
  static const double _sfxCooldownTime = 0.08;

  static Future<void> preloadAll() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.loadAll([
      'game_over.wav',
      'hit.wav',
      'level.wav',
      'shoot.wav',
      'bgm1.mp3',
      'bgm2.mp3',
      'bgm3.mp3',
      'bgm4.mp3',
    ]);
  }

  static void update(double dt) {
    if (_shootCooldown > 0) _shootCooldown -= dt;
    if (_hitCooldown > 0) _hitCooldown -= dt;
  }

  static void playShoot() {
    if (_shootCooldown > 0) return;
    _shootCooldown = _sfxCooldownTime;
    FlameAudio.play('shoot.wav', volume: 0.4);
  }

  static void playHit() {
    if (_hitCooldown > 0) return;
    _hitCooldown = _sfxCooldownTime;
    FlameAudio.play('hit.wav', volume: 0.7);
  }

  static void playLevelUp() {
    FlameAudio.play('level.wav', volume: 0.8);
  }

  static void playGameOver() {
    FlameAudio.bgm.stop();
    _isStartingTrack = false;
    FlameAudio.play('game_over.wav', volume: 0.8);
  }

  static Future<void> playNextTrack() async {
    if (_isStartingTrack) return;
    _isStartingTrack = true;

    String next;
    do {
      next = _bgmTracks[_random.nextInt(_bgmTracks.length)];
    } while (next == _lastPlayed && _bgmTracks.length > 1);

    _lastPlayed = next;
    await FlameAudio.bgm.play(next, volume: 0.5);
    _isStartingTrack = false;
  }

  static void stopBgm() {
    FlameAudio.bgm.stop();
    _isStartingTrack = false;
  }

  static void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  static void resumeBgm() {
    FlameAudio.bgm.resume();
  }
}
