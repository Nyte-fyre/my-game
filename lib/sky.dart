import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'path_of_fyre_game.dart';
import 'enemy.dart';
import 'projectile.dart';
import 'sound_manager.dart';

class Sky extends SpriteComponent
    with HasGameReference<PathOfFyreGame>, CollisionCallbacks {
  final double speed = 200;

  double maxHealth = 100;
  double currentHealth = 100;
  double damageCooldown = 0;
  final double damageCooldownTime = 0.5;
  double damagePerHit = 10;

  double _attackTimer = 0;
  double attackInterval = 0.5;
  double attackRange = 200;

  double currentXp = 0;
  double xpToNextLevel = 100;
  int level = 1;

  double _flashTimer = 0;
  final double _flashDuration = 0.15;
  bool _isFlashing = false;

  double _shakeTimer = 0;
  final double _shakeDuration = 0.3;
  final double _shakeIntensity = 6.0;
  Vector2 _basePosition = Vector2.zero();

  @override
  Future<void> onLoad() async {
    final spriteImage = await Sprite.load('sky.png');
    sprite = spriteImage;
    size = Vector2(96, 96);
    position = Vector2(300, 300);
    _basePosition = position.clone();
    add(RectangleHitbox());
  }

  void flash() {
    _isFlashing = true;
    _flashTimer = _flashDuration;
  }

  void triggerShake() {
    _basePosition = position.clone();
    _shakeTimer = _shakeDuration;
  }

  void _fireAtNearestEnemy() {
    final enemies = game.children.whereType<Enemy>().toList();
    if (enemies.isEmpty) return;

    final skyCenter = position + size / 2;

    Enemy? nearest;
    double nearestDistance = double.infinity;

    for (final enemy in enemies) {
      final enemyCenter = enemy.position + enemy.size / 2;
      final distance = (skyCenter - enemyCenter).length;
      if (distance < nearestDistance && distance <= attackRange) {
        nearestDistance = distance;
        nearest = enemy;
      }
    }

    if (nearest != null) {
      final enemyCenter = nearest.position + nearest.size / 2;
      final direction = (enemyCenter - skyCenter).normalized();
      game.add(
        Projectile(
          startPosition: skyCenter - Vector2(4, 4),
          direction: direction,
        ),
      );
      SoundManager.playShoot();
    }
  }

  void collectXp(double amount) {
    currentXp += amount;
    if (currentXp >= xpToNextLevel) {
      currentXp = 0;
      level++;
      game.showLevelUp();
    }
  }

  @override
  void render(Canvas canvas) {
    if (_isFlashing) {
      paint.colorFilter = ColorFilter.mode(
        Colors.red.withOpacity(0.7),
        BlendMode.srcATop,
      );
    } else {
      paint.colorFilter = null;
    }
    super.render(canvas);
  }

  @override
  void update(double dt) {
    if (game.isGameOver || game.isLevelingUp) return;

    // Handle shake
    if (_shakeTimer > 0) {
      _shakeTimer -= dt;
      final random = Random();
      position =
          _basePosition +
          Vector2(
            (random.nextDouble() - 0.5) * _shakeIntensity,
            (random.nextDouble() - 0.5) * _shakeIntensity,
          );
    } else if (_shakeTimer <= 0 && _shakeTimer > -0.1) {
      position = _basePosition;
    }

    // Handle flash timer
    if (_isFlashing) {
      _flashTimer -= dt;
      if (_flashTimer <= 0) {
        _isFlashing = false;
      }
    }

    // Auto attack
    _attackTimer += dt;
    if (_attackTimer >= attackInterval) {
      _attackTimer = 0;
      _fireAtNearestEnemy();
    }

    // Damage cooldown
    if (damageCooldown > 0) {
      damageCooldown -= dt;
    }

    // Check enemy collisions
    final enemies = game.children.whereType<Enemy>();
    final skyCenter = position + size / 2;

    for (final enemy in enemies) {
      final enemyCenter = enemy.position + enemy.size / 2;
      final distance = (skyCenter - enemyCenter).length;
      final minDistance = (size.x / 2) + (enemy.size.x / 2);

      if (distance < minDistance && damageCooldown <= 0) {
        currentHealth -= damagePerHit;
        damageCooldown = damageCooldownTime;
        flash();
        game.shakeScreen();
        SoundManager.playHit();
        if (currentHealth <= 0) {
          currentHealth = 0;
          game.skyDied();
        }
      }
    }

    // Movement
    if (HardwareKeyboard.instance.isLogicalKeyPressed(
      LogicalKeyboardKey.arrowUp,
    )) {
      position.y -= speed * dt;
    }
    if (HardwareKeyboard.instance.isLogicalKeyPressed(
      LogicalKeyboardKey.arrowDown,
    )) {
      position.y += speed * dt;
    }
    if (HardwareKeyboard.instance.isLogicalKeyPressed(
      LogicalKeyboardKey.arrowLeft,
    )) {
      position.x -= speed * dt;
    }
    if (HardwareKeyboard.instance.isLogicalKeyPressed(
      LogicalKeyboardKey.arrowRight,
    )) {
      position.x += speed * dt;
    }

    position.x = position.x.clamp(0, game.size.x - size.x);
    position.y = position.y.clamp(0, game.size.y - size.y);

    // Keep base position updated when not shaking
    if (_shakeTimer <= 0) {
      _basePosition = position.clone();
    }
  }
}
