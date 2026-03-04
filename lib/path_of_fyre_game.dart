import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'sky.dart';
import 'enemy_spawner.dart';
import 'hud.dart';
import 'game_over_screen.dart';
import 'enemy.dart';
import 'level_up_screen.dart';
import 'main_menu.dart';
import 'sound_manager.dart';

class PathOfFyreGame extends FlameGame with HasCollisionDetection {
  late Sky sky;
  bool isGameOver = false;
  bool isLevelingUp = false;
  double timeSurvived = 0;
  int enemiesKilled = 0;

  @override
  Future<void> onLoad() async {
    await SoundManager.preloadAll();
    add(MainMenu());
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isGameOver && !isLevelingUp) {
      timeSurvived += dt;
    }

    // Rotate tracks when one finishes
    if (!isGameOver && !isLevelingUp && !FlameAudio.bgm.isPlaying) {
      SoundManager.playNextTrack();
    }
  }

  void shakeScreen() {
    sky.triggerShake();
  }

  Future<void> startGame() async {
    isGameOver = false;
    isLevelingUp = false;
    timeSurvived = 0;
    enemiesKilled = 0;

    add(
      SpriteComponent(
        sprite: await Sprite.load('background.jpg'),
        size: size,
        position: Vector2(size.x, size.y),
        anchor: Anchor.bottomRight,
        priority: -1,
      ),
    );

    sky = Sky();
    add(sky);
    add(EnemySpawner(target: sky));
    add(Hud());
    SoundManager.playNextTrack();
  }

  void skyDied() {
    isGameOver = true;
    SoundManager.playGameOver();
    add(GameOverScreen());
  }

  void showLevelUp() {
    isLevelingUp = true;
    SoundManager.playLevelUp();
    add(LevelUpScreen());
  }

  void resetGame() {
    isGameOver = false;
    isLevelingUp = false;
    SoundManager.stopBgm();
    sky.resetStats();
    children.whereType<Enemy>().forEach((e) => e.removeFromParent());
    sky.removeFromParent();
    children.whereType<EnemySpawner>().forEach((e) => e.removeFromParent());
    children.whereType<Hud>().forEach((e) => e.removeFromParent());
    children.whereType<GameOverScreen>().forEach((e) => e.removeFromParent());
    children.whereType<LevelUpScreen>().forEach((e) => e.removeFromParent());
    children.whereType<SpriteComponent>().forEach((e) => e.removeFromParent());
    startGame();
  }
}
