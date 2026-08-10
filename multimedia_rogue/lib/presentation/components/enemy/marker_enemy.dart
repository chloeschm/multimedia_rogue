import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/presentation/components/enemy/enemy_display.dart';
import 'package:multimedia_rogue/presentation/components/weapons/weapon_pickup.dart';

class MarkerEnemyDisplay extends EnemyDisplay {
  static const int spawnCount = 10;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final random = Random();
    final dropperIndex = random.nextInt(spawnCount);

    for (int i = 0; i < spawnCount; i++) {
      add(
        MarkerEnemy(
          position: Vector2(
            random.nextDouble() * game.size.x,
            random.nextDouble() * game.size.y,
          ),
          size: Vector2(64, 64 * 841 / 739),
          isWatercolorDropper: i == dropperIndex,
        ),
      );
    }
  }
}

class MarkerEnemy extends Enemy {
  static final Vector2 _frameSize = Vector2(739, 841);
  static const double _runAnimationSpeed = 0.3;

  final bool isWatercolorDropper;

  final Random _random = Random();
  final Vector2 _velocity = Vector2.zero();
  double _jitterTimer = 0.0;

  late ui.Image _spriteSheet;
  double _runAnimationTimer = 0.0;

  MarkerEnemy({
    required super.position,
    required super.size,
    this.isWatercolorDropper = false,
  }) : super(speed: 190.0, maxHp: 1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _spriteSheet = await game.images.load('markerenemysheet.png');
    sprite = Sprite(
      _spriteSheet,
      srcPosition: Vector2.zero(),
      srcSize: _frameSize,
    );
  }

  @override
  void behave(double dt) {
    _jitterTimer -= dt;
    if (_jitterTimer <= 0) {
      _jitterTimer = 0.5 + _random.nextDouble() * 1.3;
      final angle = _random.nextDouble() * pi * 2;
      _velocity.setValues(cos(angle) * speed, sin(angle) * speed);
    }

    position += _velocity * dt;

    if (position.x < 0) {
      position.x = 0;
      _velocity.x = _velocity.x.abs();
    } else if (position.x > game.size.x - size.x) {
      position.x = game.size.x - size.x;
      _velocity.x = -_velocity.x.abs();
    }
    if (position.y < 0) {
      position.y = 0;
      _velocity.y = _velocity.y.abs();
    } else if (position.y > game.size.y - size.y) {
      position.y = game.size.y - size.y;
      _velocity.y = -_velocity.y.abs();
    }
  }

  @override
  void die() {
    if (isWatercolorDropper) {
      parent?.add(
        WeaponPickup(
          position: position + size / 2,
          mediumType: MediumType.watercolor,
        ),
      );
    }
    super.die();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _runAnimationTimer += dt;
    final col = (_runAnimationTimer ~/ _runAnimationSpeed) % 2 == 0
        ? 0.0
        : _frameSize.x;
    sprite = Sprite(
      _spriteSheet,
      srcPosition: Vector2(col, 0),
      srcSize: _frameSize,
    );
  }
}
