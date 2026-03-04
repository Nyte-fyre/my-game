import 'package:flame/components.dart';
import 'path_of_fyre_game.dart';

class XpOrb extends SpriteComponent with HasGameReference<PathOfFyreGame> {
  final double xpValue = 10;
  final double attractRadius = 120;
  final double moveSpeed = 180;

  XpOrb({required Vector2 spawnPosition}) {
    position = spawnPosition;
  }

  @override
  Future<void> onLoad() async {
    final spriteImage = await Sprite.load('xp_orb.png');
    sprite = spriteImage;
    size = Vector2(24, 24);
  }

  @override
  void update(double dt) {
    if (game.isGameOver) return;

    final orbCenter = position + size / 2;
    final skyCenter = game.sky.position + game.sky.size / 2;
    final distance = (orbCenter - skyCenter).length;

    // Move toward player when within attract radius
    if (distance < attractRadius) {
      final direction = (skyCenter - orbCenter).normalized();
      position += direction * moveSpeed * dt;
    }

    // Collect when close enough
    if (distance < 20) {
      game.sky.collectXp(xpValue);
      removeFromParent();
    }
  }
}
