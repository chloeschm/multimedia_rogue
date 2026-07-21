import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/enemy/enemy_display.dart';

class InkShot extends PositionComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  static const Color _ink = Color(0xFF1B2430);
  static const double _speed = 520.0;

  final Vector2 direction;

  InkShot({required this.direction, required Vector2 position})
    : super(
        position: position,
        size: Vector2.all(14),
        anchor: Anchor.center,
        priority: -5,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += direction * _speed * dt;
    if (position.x < -60 ||
        position.x > game.size.x + 60 ||
        position.y < -60 ||
        position.y > game.size.y + 60) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Enemy) {
      other.die();
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final back = -direction.x.sign;

    for (int i = 2; i >= 1; i--) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx + back * i * 6.0, center.dy),
          width: 8.0 - i * 2.0,
          height: 6.0 - i * 1.5,
        ),
        Paint()
          ..color = _ink.withOpacity(0.30 - i * 0.10)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
      );
    }

    canvas.drawCircle(
      center,
      5.0,
      Paint()
        ..color = _ink.withOpacity(0.85)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.8),
    );
    canvas.drawCircle(
      Offset(center.dx + direction.x.sign * 2.5, center.dy - 1.5),
      1.6,
      Paint()..color = Colors.white.withOpacity(0.35),
    );
  }
}
