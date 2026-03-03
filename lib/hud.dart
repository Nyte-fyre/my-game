import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'path_of_fyre_game.dart';

class Hud extends PositionComponent with HasGameReference<PathOfFyreGame> {
  late final Paint _healthBarBg;
  late final Paint _healthBarFill;

  Hud() : super(priority: 10);

  @override
  Future<void> onLoad() async {
    _healthBarBg = Paint()..color = Colors.red.shade900;
    _healthBarFill = Paint()..color = Colors.green;
  }

  void _drawText(
    Canvas canvas,
    String text,
    double x,
    double y,
    double fontSize,
    Color color,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: fontSize),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(x, y));
  }

  @override
  void render(Canvas canvas) {
    final barWidth = 200.0;
    final barHeight = 20.0;
    final x = 20.0;
    final y = 20.0;

    // Health bar background
    canvas.drawRect(Rect.fromLTWH(x, y, barWidth, barHeight), _healthBarBg);

    // Health bar fill
    final healthPercent = game.sky.currentHealth / game.sky.maxHealth;
    canvas.drawRect(
      Rect.fromLTWH(x, y, barWidth * healthPercent, barHeight),
      _healthBarFill,
    );

    // XP bar background
    final xpBarY = y + barHeight + 8;
    canvas.drawRect(
      Rect.fromLTWH(x, xpBarY, barWidth, 12),
      Paint()..color = Colors.grey.shade800,
    );

    // XP bar fill
    final xpPercent = game.sky.currentXp / game.sky.xpToNextLevel;
    canvas.drawRect(
      Rect.fromLTWH(x, xpBarY, barWidth * xpPercent, 12),
      Paint()..color = Colors.purple,
    );

    // Level text
    _drawText(
      canvas,
      'Level ${game.sky.level}',
      x + barWidth + 10,
      y + 5,
      16,
      Colors.white,
    );
  }
}
