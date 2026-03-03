import 'package:flame/components.dart';
import 'path_of_fyre_game.dart';

class XpOrb extends SpriteComponent with HasGameReference<PathOfFyreGame> {
  final double xpValue = 10;

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

    if (distance < 30) {
      game.sky.collectXp(xpValue);
      removeFromParent();
    }
  }
}
