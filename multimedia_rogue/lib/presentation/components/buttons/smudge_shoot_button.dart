import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class SmudgeShootButton extends PositionComponent with TapCallbacks {
  final void Function(bool pressed) onShoot;

  SmudgeShootButton({required this.onShoot});

  static const Color _graphite = Color(0xFF3A3A3A);

  bool _pressed = false;
  double _pressT = 0.0;

  @override
  void onTapDown(TapDownEvent event) {
    _pressed = true;
    onShoot(true);
  }

  @override
  void onTapUp(TapUpEvent event) {
    _pressed = false;
    onShoot(false);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _pressed = false;
    onShoot(false);
  }

  @override
  void update(double dt) {
    super.update(dt);
    final target = _pressed ? 1.0 : 0.0;
    _pressT += (target - _pressT) * (dt * 14).clamp(0.0, 1.0);
  }

  @override
  void render(Canvas canvas) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    final center = Offset(cx, cy);
    final radius = size.x * 0.38;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = _graphite.withOpacity(0.12 + 0.10 * _pressT)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

 
    final coreW = radius * 1.15 * (1.0 - 0.08 * _pressT);
    final coreH = radius * 0.78 * (1.0 - 0.08 * _pressT);
    for (int layer = 0; layer < 4; layer++) {
      final dx = (layer - 1.5) * 3.0;
      final opacity = (0.50 - layer * 0.09) + 0.18 * _pressT;
      final blur = 3.5 + layer * 1.8;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx + dx, center.dy + 1.2 * layer),
          width: coreW - layer * 2.5,
          height: coreH - layer * 2.0,
        ),
        Paint()
          ..color = _graphite.withOpacity(opacity.clamp(0.0, 1.0))
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur),
      );
    }

    canvas.drawCircle(
      center,
      4.5 + 1.5 * _pressT,
      Paint()
        ..color = _graphite.withOpacity(0.30 + 0.25 * _pressT)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
  }
}
