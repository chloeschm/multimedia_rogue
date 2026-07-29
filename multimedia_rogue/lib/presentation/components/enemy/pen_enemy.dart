import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/presentation/components/enemy/enemy_display.dart';
import 'package:multimedia_rogue/presentation/components/weapons/weapon_pickup.dart';

class PenEnemyDisplay extends EnemyDisplay {
  static const int spawnCount = 10;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final random = Random();
    final markerDropperIndex = random.nextInt(spawnCount);

    for (int i = 0; i < spawnCount; i++) {
      add(
        PenEnemy(
          position: Vector2(
            random.nextDouble() * game.size.x,
            random.nextDouble() * game.size.y,
          ),
          size: Vector2(58, 58 * 395 / 316),
          isMarkerDropper: i == markerDropperIndex,
        ),
      );
    }
  }
}

class PenEnemy extends Enemy {
  static final Vector2 _frameSize = Vector2(316, 395);
  static const double _runAnimationSpeed = 0.6;

  final bool isMarkerDropper;

  late ui.Image _spriteSheet;
  double _runAnimationTimer = 0.0;

  PenEnemy({
    required super.position,
    required super.size,
    this.isMarkerDropper = false,
  }) : super(speed: 85.0, chasePack: 3);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _spriteSheet = await game.images.load('penenemysheet.png');
    sprite = Sprite(
      _spriteSheet,
      srcPosition: Vector2.zero(),
      srcSize: _frameSize,
    );
  }

  @override
  void die() {
    if (isMarkerDropper) {
      dropMarker();
    }
    super.die();
  }

  void dropMarker() {
    parent?.add(
      WeaponPickup(
        position: position + size / 2,
        mediumType: MediumType.marker,
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
