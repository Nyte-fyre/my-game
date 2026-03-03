import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'dart:math';
import 'path_of_fyre_game.dart';
import 'xp_orb.dart';
import 'death_flash.dart';

class Enemy extends SpriteComponent
    with HasGameReference<PathOfFyreGame>, CollisionCallbacks {
  final double speed = 80;
  late final PositionComponent target;

  double maxHealth = 40;
  double currentHealth = 40;

  Enemy({required this.target});

  @override
  Future<void> onLoad() async {
    final spriteImage = await Sprite.load('enemy.png');
    sprite = spriteImage;
    size = Vector2(64, 64);
    position = _randomEdgePosition();
    add(RectangleHitbox());
  }

  void takeDamage(double damage) {
    currentHealth -= damage;
    if (currentHealth <= 0) {
      game.enemiesKilled++;
      game.add(DeathFlash(spawnPosition: position.clone()));
      game.add(XpOrb(spawnPosition: position.clone()));
      removeFromParent();
    }
  }

  Vector2 _randomEdgePosition() {
    final random = Random();
    final edge = random.nextInt(4);
    final screenWidth = game.size.x;
    final screenHeight = game.size.y;

    switch (edge) {
      case 0:
        return Vector2(random.nextDouble() * screenWidth, 0);
      case 1:
        return Vector2(random.nextDouble() * screenWidth, screenHeight);
      case 2:
        return Vector2(0, random.nextDouble() * screenHeight);
      default:
        return Vector2(screenWidth, random.nextDouble() * screenHeight);
    }
  }

  @override
  void update(double dt) {
    if (game.isGameOver || game.isLevelingUp) return;
    final targetCenter = target.position + target.size / 2;
    final myCenter = position + size / 2;
    final direction = (targetCenter - myCenter).normalized();
    position += direction * speed * dt;
  }
}
