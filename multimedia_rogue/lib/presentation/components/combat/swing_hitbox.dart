import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:multimedia_rogue/presentation/components/enemy/enemy_display.dart';

class SwingHitbox extends PositionComponent with CollisionCallbacks {
  final int damage;
  final Vector2 offset;
  final double radius;
  final Vector2 weaponSize;

  SwingHitbox({
    required this.damage,
    required this.offset,
    required this.radius,
    required this.weaponSize,
  });

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(
      CircleHitbox.relative(
        radius,
        parentSize: weaponSize,
        position: offset,
        anchor: Anchor.center,
      ),
    );
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      other.takeHit(damage);
    }
  }
}
