import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/main.dart';

class ExitDoor extends PositionComponent with HasGameReference<MyGame> {
  static const Color _graphite = Color(0xFF3A3A3A);

  bool isOpen = false;

  double _time = 0.0;
  double _glowT = 0.0;

  @override
  void onMount() {
    super.onMount();
    game.exitDoor = this;
  }

  @override
  void onRemove() {
    if (game.exitDoor == this) game.exitDoor = null;
    super.onRemove();
  }

  void open() {
    isOpen = true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    final target = isOpen ? 1.0 : 0.0;
    _glowT += (target - _glowT) * (dt * 5).clamp(0.0, 1.0);
  }

  @override
  void render(Canvas canvas) {
    final cx = size.x / 2;
    final glow = 0.15 + 0.5 * _glowT;

    for (int layer = 3; layer >= 0; layer--) {
      final opacity = (glow / (layer + 1)).clamp(0.0, 1.0);
      canvas.drawLine(
        Offset(cx, 0),
        Offset(cx, size.y),
        Paint()
          ..color = _graphite.withOpacity(opacity)
          ..strokeWidth = 2.0 + layer * 3.0
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5 + layer * 2.0),
      );
    }

    final squiggleCount = 1 + (3 * _glowT).round();
    for (int s = 0; s < squiggleCount; s++) {
      final phase = _time * (1.2 + s * 0.5) + s * 2.1;
      final amp = (4.0 + s * 3.0) * (0.6 + 0.9 * _glowT);
      final path = Path()..moveTo(cx + sin(phase) * amp, 0);
      const steps = 12;
      for (int i = 1; i <= steps; i++) {
        final y = size.y * i / steps;
        final x = cx + sin(phase + i * 0.9) * amp;
        path.lineTo(x, y);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color =
              _graphite.withOpacity((0.18 + 0.28 * _glowT).clamp(0.0, 1.0))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.8),
      );
    }
  }
}
