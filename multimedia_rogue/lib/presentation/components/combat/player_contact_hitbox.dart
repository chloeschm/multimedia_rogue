import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/enemy/enemy_display.dart';

class PlayerContactHitbox extends CircleHitbox with HasGameReference<MyGame> {
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other.hitboxParent is Enemy) {
      game.player.takeDamage(1);
      game.healthBar?.updateHealth(game.player.hp);
    }
  }
}
