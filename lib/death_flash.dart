import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DeathFlash extends PositionComponent {
  double _timer = 0.2;
  final double _maxTimer = 0.2;
  late final Paint _paint;

  DeathFlash({required Vector2 spawnPosition}) {
    position = spawnPosition;
  }

  @override
  Future<void> onLoad() async {
    size = Vector2(64, 64);
    _paint = Paint()..color = Colors.white;
  }

  @override
  void render(Canvas canvas) {
    final opacity = (_timer / _maxTimer).clamp(0.0, 1.0);
    final radius = (1 - opacity) * 40 + 10;
    _paint.color = Colors.white.withOpacity(opacity);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), radius, _paint);
  }

  @override
  void update(double dt) {
    _timer -= dt;
    if (_timer <= 0) {
      removeFromParent();
    }
  }
}
