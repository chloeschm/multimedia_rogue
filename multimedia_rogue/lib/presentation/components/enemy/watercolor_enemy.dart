import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/presentation/components/character/character_display.dart';
import 'package:multimedia_rogue/presentation/components/enemy/enemy_display.dart';

class WatercolorEnemyDisplay extends EnemyDisplay {
  static const int clusterCount = 3;
  static const int perCluster = 3;

  bool _seenEnemies = false;
  bool _doorOpened = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final random = Random();

    for (int c = 0; c < clusterCount; c++) {
      final center = Vector2(
        game.size.x * (0.25 + random.nextDouble() * 0.55),
        game.size.y * (0.2 + random.nextDouble() * 0.6),
      );
      for (int j = 0; j < perCluster; j++) {
        final angle = (j / perCluster) * pi * 2 + random.nextDouble();
        add(
          WatercolorEnemy(
            position: center + Vector2(cos(angle), sin(angle)) * 70,
            size: Vector2(74, 74 * 841 / 739),
          ),
        );
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final alive = children.whereType<Enemy>().isNotEmpty;
    if (alive) {
      _seenEnemies = true;
    } else if (_seenEnemies && !_doorOpened) {
      _doorOpened = true;
      game.exitDoor?.open();
    }
  }
}

class WatercolorEnemy extends Enemy {
  static final Vector2 _frameSize = Vector2(739, 841);
  static const double _runAnimationSpeed = 0.6;

  final Random _random = Random();
  double _puddleTimer = 1.5;

  late ui.Image _spriteSheet;
  double _runAnimationTimer = 0.0;

  WatercolorEnemy({required super.position, required super.size})
    : super(speed: 60.0, chasePack: 4, maxHp: 3);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _spriteSheet = await game.images.load('watercolorenemysheet.png');
    sprite = Sprite(
      _spriteSheet,
      srcPosition: Vector2.zero(),
      srcSize: _frameSize,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    _puddleTimer -= dt;
    if (_puddleTimer <= 0) {
      _puddleTimer = 2.0 + _random.nextDouble() * 1.5;
      parent?.add(Puddle(position: position + size / 2));
    }

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

class Puddle extends PositionComponent with CollisionCallbacks {
  static const double _lifespan = 8.0;
  static const double _growTime = 1.2;
  static const double _fadeTime = 1.5;
  static const Color _wash = Color(0xFF4A7BA6);

  final double maxRadius;
  double _age = 0.0;

  Puddle({required Vector2 position, this.maxRadius = 72})
    : super(
        position: position,
        size: Vector2.all(maxRadius * 2),
        anchor: Anchor.center,
        priority: -1,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      CircleHitbox.relative(
        0.85,
        parentSize: size,
        position: size / 2,
        anchor: Anchor.center,
      )..collisionType = CollisionType.passive,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    if (_age >= _lifespan) removeFromParent();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is CharacterDisplay) other.enterPuddle();
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is CharacterDisplay) other.exitPuddle();
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final grow = (_age / _growTime).clamp(0.0, 1.0);
    final fade = _age > _lifespan - _fadeTime
        ? ((_lifespan - _age) / _fadeTime).clamp(0.0, 1.0)
        : 1.0;
    final radius = maxRadius * (0.4 + 0.6 * grow);

    for (int layer = 0; layer < 3; layer++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx + (layer - 1) * 4.0, center.dy),
          width: radius * 2 * (1.0 - layer * 0.18),
          height: radius * 1.5 * (1.0 - layer * 0.18),
        ),
        Paint()
          ..color = _wash.withOpacity(
            ((0.10 + layer * 0.06) * fade).clamp(0.0, 1.0),
          )
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0 - layer * 2.5),
      );
    }
  }
}
