import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/presentation/components/enemy/enemy_display.dart';
import 'package:multimedia_rogue/presentation/components/weapons/weapon_pickup.dart';

class PencilEnemyDisplay extends EnemyDisplay {
  static const int spawnCount = 5;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final random = Random();
    final penDropperIndex = random.nextInt(spawnCount);

    for (int i = 0; i < spawnCount; i++) {
      add(
        PencilEnemy(
          position: Vector2(
            random.nextDouble() * game.size.x,
            random.nextDouble() * game.size.y,
          ),
          size: Vector2(82, 82 * 2077 / 1920),
          isPenDropper: i == penDropperIndex,
        ),
      );
    }
  }
}

class PencilEnemy extends Enemy {
  static final Vector2 _frameSize = Vector2(1920, 2077);
  static const double _runAnimationSpeed = 0.6;

  final bool isPenDropper;

  late ui.Image _spriteSheet;
  double _runAnimationTimer = 0.0;

  PencilEnemy({
    required super.position,
    required super.size,
    this.isPenDropper = false,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _spriteSheet = await game.images.load('pencilenemysheet.jpg');
    sprite = Sprite(
      _spriteSheet,
      srcPosition: Vector2.zero(),
      srcSize: _frameSize,
    );
  }

  @override
  void die() {
    if (isPenDropper) {
      dropPen();
    }
    super.die();
  }

  void dropPen() {
    parent?.add(
      WeaponPickup(
        position: position + size / 2,
        mediumType: MediumType.pen,
      ),
    );
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
