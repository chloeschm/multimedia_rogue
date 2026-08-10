import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/presentation/components/enemy/enemy_display.dart';

class MarkerTrailSegment extends PositionComponent with CollisionCallbacks {
  static const Color _inkColor = Color(0xFF2C7FE0);

  bool _smudged = false;
  double _fade = 1.0;

  MarkerTrailSegment({required Vector2 position})
    : super(
        position: position,
        size: Vector2.all(20),
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(CircleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_smudged) {
      _fade -= dt * 2.5;
      if (_fade <= 0) removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (_smudged) return;
    if (other is Enemy) {
      other.takeHit(1);
      _smudged = true;
      children.whereType<CircleHitbox>().toList().forEach(
        (h) => h.removeFromParent(),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    final opacity = _smudged ? (_fade * 0.5).clamp(0.0, 1.0) : 0.85;
    final spread = _smudged ? 1.0 + (1.0 - _fade) * 0.8 : 1.0;
    canvas.drawCircle(
      center,
      9.0 * spread,
      Paint()..color = _inkColor.withOpacity(opacity),
    );
    canvas.drawCircle(
      center.translate(3, -2),
      5.0 * spread,
      Paint()..color = _inkColor.withOpacity(opacity * 0.7),
    );
  }
}
