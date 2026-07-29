import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';

abstract class EnemyDisplay extends PositionComponent
    with HasGameReference<MyGame> {
  @override
  void onMount() {
    super.onMount();
    game.enemyDisplay = this;
  }
}

abstract class Enemy extends SpriteComponent with HasGameReference<MyGame> {
  final double speed;
  final int chasePack;

  Enemy({
    required Vector2 position,
    required Vector2 size,
    this.speed = 50.0,
    this.chasePack = 1,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      CircleHitbox.relative(
        0.65,
        parentSize: size,
        position: size / 2,
        anchor: Anchor.center,
      )..collisionType = CollisionType.active,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    final playerPos = (game.characterDisplay as PositionComponent?)?.position;
    if (playerPos != null && _isNearestToPlayer(playerPos)) {
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
  }

  bool _isNearestToPlayer(Vector2 playerPos) {
    final siblings = parent?.children.whereType<Enemy>();
    if (siblings == null) return true;
    final myDistance = position.distanceToSquared(playerPos);
    var closer = 0;
    for (final enemy in siblings) {
      if (enemy == this) continue;
      if (enemy.position.distanceToSquared(playerPos) < myDistance) {
        closer++;
        if (closer >= chasePack) return false;
      }
    }
    return true;
  }

  void die() {
    removeFromParent();
  }
}
