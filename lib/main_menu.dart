import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'path_of_fyre_game.dart';
import 'sound_manager.dart';

class MainMenu extends PositionComponent with HasGameReference<PathOfFyreGame> {
  late final Paint _bgPaint;
  bool _spaceWasPressed = false;

  MainMenu() : super(priority: 20);

  @override
  Future<void> onLoad() async {
    size = game.size;
    position = Vector2.zero();
    _bgPaint = Paint()..color = Colors.black.withOpacity(0.85);
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
      'PATH OF FYRE',
      size.x / 2,
      size.y / 4,
      56,
      Colors.orange,
      bold: true,
    );

    // Tagline
    _drawText(
      canvas,
      'One warrior. Endless darkness.',
      size.x / 2,
      size.y / 4 + 60,
      20,
      Colors.grey,
    );

    // Controls
    _drawText(
      canvas,
      'Arrow Keys to Move',
      size.x / 2,
      size.y / 2,
      18,
      Colors.white,
    );
    _drawText(
      canvas,
      'Auto Attack Nearest Enemy',
      size.x / 2,
      size.y / 2 + 30,
      18,
      Colors.white,
    );
    _drawText(
      canvas,
      'Collect XP to Level Up',
      size.x / 2,
      size.y / 2 + 60,
      18,
      Colors.white,
    );

    // Start prompt
    _drawText(
      canvas,
      'Press SPACE to Begin',
      size.x / 2,
      size.y * 0.78,
      24,
      Colors.yellow,
      bold: true,
    );

    // Version
    _drawText(canvas, 'v0.1.0', size.x / 2, size.y * 0.92, 14, Colors.grey);
  }

  @override
  void update(double dt) {
    final spacePressed = HardwareKeyboard.instance.isLogicalKeyPressed(
      LogicalKeyboardKey.space,
    );

    if (spacePressed && !_spaceWasPressed) {
      SoundManager.playGameStart();
      game.startGame();
      removeFromParent();
    }

    _spaceWasPressed = spacePressed;
  }
}
