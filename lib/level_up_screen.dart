import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'path_of_fyre_game.dart';

class LevelUpScreen extends PositionComponent
    with HasGameReference<PathOfFyreGame> {
  late final Paint _bgPaint;
  int _selected = 0;
  bool _upWasPressed = false;
  bool _downWasPressed = false;
  bool _spaceWasPressed = false;

  final List<String> _options = ['Damage Up', 'Attack Speed Up', 'Range Up'];

  LevelUpScreen() : super(priority: 20);

  @override
  Future<void> onLoad() async {
    size = game.size;
    position = Vector2.zero();
    _bgPaint = Paint()..color = Colors.black.withOpacity(0.7);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _bgPaint);

    _drawText(
      canvas,
      'LEVEL UP!',
      size.x / 2,
      size.y / 4,
      40,
      Colors.yellow,
      bold: true,
    );
    _drawText(
      canvas,
      'Choose an upgrade:',
      size.x / 2,
      size.y / 4 + 55,
      20,
      Colors.white,
    );

    for (int i = 0; i < _options.length; i++) {
      final isSelected = i == _selected;
      final color = isSelected ? Colors.yellow : Colors.white;
      final prefix = isSelected ? '>>> ' : '       ';
      _drawText(
        canvas,
        '$prefix${_options[i]}',
        size.x / 2,
        size.y / 2 + (i * 50),
        24,
        color,
        bold: isSelected,
      );
    }

    _drawText(
      canvas,
      'UP/DOWN to select, SPACE to confirm',
      size.x / 2,
      size.y * 0.8,
      16,
      Colors.grey,
    );
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
  void update(double dt) {
    final upPressed = HardwareKeyboard.instance.isLogicalKeyPressed(
      LogicalKeyboardKey.arrowUp,
    );
    final downPressed = HardwareKeyboard.instance.isLogicalKeyPressed(
      LogicalKeyboardKey.arrowDown,
    );
    final spacePressed = HardwareKeyboard.instance.isLogicalKeyPressed(
      LogicalKeyboardKey.space,
    );

    if (upPressed && !_upWasPressed) {
      _selected = (_selected - 1).clamp(0, _options.length - 1);
    }
    if (downPressed && !_downWasPressed) {
      _selected = (_selected + 1).clamp(0, _options.length - 1);
    }
    if (spacePressed && !_spaceWasPressed) {
      _applyUpgrade();
    }

    _upWasPressed = upPressed;
    _downWasPressed = downPressed;
    _spaceWasPressed = spacePressed;
  }

  void _applyUpgrade() {
    switch (_selected) {
      case 0:
        game.sky.damagePerHit += 5;
        break;
      case 1:
        if (game.sky.attackInterval > 0.1) {
          game.sky.attackInterval -= 0.1;
        }
        break;
      case 2:
        game.sky.attackRange += 50;
        break;
    }
    game.isLevelingUp = false;
    removeFromParent();
  }
}
