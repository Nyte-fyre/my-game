import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'path_of_fyre_game.dart';

class GameOverScreen extends PositionComponent
    with HasGameReference<PathOfFyreGame> {
  late final Paint _bgPaint;

  GameOverScreen() : super(priority: 20);

  @override
  Future<void> onLoad() async {
    size = game.size;
    position = Vector2.zero();
    _bgPaint = Paint()..color = Colors.black.withOpacity(0.7);
  }

  void _drawText(
    Canvas canvas,
    String text,
    double x,
    double y,
    double fontSize,
    Color color, {
    bool bold = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      Offset(x - painter.width / 2, y - painter.height / 2),
    );
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _bgPaint);

    // Title
    _drawText(
      canvas,
      'GAME OVER',
      size.x / 2,
      size.y / 4,
      48,
      Colors.red,
      bold: true,
    );

    // Score
    final minutes = (game.timeSurvived / 60).floor();
    final seconds = (game.timeSurvived % 60).floor();
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    _drawText(
      canvas,
      'Time Survived: $timeString',
      size.x / 2,
      size.y / 2 - 40,
      24,
      Colors.white,
    );
    _drawText(
      canvas,
      'Enemies Killed: ${game.enemiesKilled}',
      size.x / 2,
      size.y / 2,
      24,
      Colors.white,
    );
    _drawText(
      canvas,
      'Level Reached: ${game.sky.level}',
      size.x / 2,
      size.y / 2 + 40,
      24,
      Colors.white,
    );

    // Restart prompt
    _drawText(
      canvas,
      'Press SPACE to Play Again',
      size.x / 2,
      size.y * 0.75,
      20,
      Colors.grey,
    );
  }

  @override
  void update(double dt) {
    if (HardwareKeyboard.instance.isLogicalKeyPressed(
      LogicalKeyboardKey.space,
    )) {
      game.resetGame();
    }
  }
}
