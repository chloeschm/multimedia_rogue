import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/character/character_display.dart';

class EnemyDisplay extends PositionComponent with HasGameReference<MyGame> {
  @override
  void onMount() {
    super.onMount();
    game.enemyDisplay = this;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final random = Random();
    for (int i = 0; i < 5; i++) {
      add(
        Enemy(
          position: Vector2(
            random.nextDouble() * game.size.x,
            random.nextDouble() * game.size.y,
          ),
          size: Vector2(82, 82),
        ),
      );
    }
  }
}

class Enemy extends SpriteComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  late ui.Image spriteSheet;
  double runAnimationTimer = 0.0;
  final double runAnimationSpeed = 0.6;
  final speed = 50.0;

  Enemy({required Vector2 position, required Vector2 size})
    : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox()..collisionType = CollisionType.active);
    spriteSheet = await game.images.load('pencilenemysheet.jpg');
    sprite = Sprite(
      spriteSheet,
      srcPosition: Vector2(0, 0),
      srcSize: Vector2(1920, 2077),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    final playerPos = (game.characterDisplay as PositionComponent?)?.position;
    if (playerPos != null) {
      final toPlayer = playerPos - position;
      if (toPlayer.length2 > 0.01) {
        position += toPlayer.normalized() * speed * dt;
      }
    }

    for (var enemy in parent!.children.whereType<Enemy>()) {
      if (enemy == this) continue;
      final offset = position - enemy.position;
      final distance = offset.length;
      if (distance < 75 && offset.length2 > 0.01) {
        final pushBack = offset.normalized();
        position += pushBack * speed * 1.5 * dt;
      }
    }

    runAnimationTimer += dt;
    final col = (runAnimationTimer ~/ runAnimationSpeed) % 2 == 0
        ? 0.0
        : 1920.0;
    sprite = Sprite(
      spriteSheet,
      srcPosition: Vector2(col, 0),
      srcSize: Vector2(1920, 2077),
    );
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is CharacterDisplay) {}
  }
}
