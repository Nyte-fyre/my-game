import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'path_of_fyre_game.dart';
import 'enemy.dart';

class Projectile extends SpriteComponent
    with HasGameReference<PathOfFyreGame>, CollisionCallbacks {
  final Vector2 direction;
  final double speed = 400;
  final double damage = 20;
  bool _hasHit = false;

  Projectile({required Vector2 startPosition, required this.direction}) {
    position = startPosition;
  }

  @override
  Future<void> onLoad() async {
    final spriteImage = await Sprite.load('projectile.png');
    sprite = spriteImage;
    size = Vector2(32, 32);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (game.isGameOver) return;

    position += direction * speed * dt;

    // Remove if off screen
    if (position.x < 0 ||
        position.x > game.size.x ||
        position.y < 0 ||
        position.y > game.size.y) {
      removeFromParent();
    }

    // Check collision with enemies
    if (!_hasHit) {
      final enemies = game.children.whereType<Enemy>().toList();
      final projectileCenter = position + size / 2;

      for (final enemy in enemies) {
        final enemyCenter = enemy.position + enemy.size / 2;
        final distance = (projectileCenter - enemyCenter).length;
        final minDistance = (size.x / 2) + (enemy.size.x / 2);

        if (distance < minDistance) {
          _hasHit = true;
          enemy.takeDamage(damage);
          removeFromParent();
          break;
        }
      }
    }
  }
}
