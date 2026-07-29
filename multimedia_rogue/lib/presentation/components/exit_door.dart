import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/character/character_display.dart';

class PenExitDoor extends ExitDoor {
  PenExitDoor({super.onEnter});

  static const Color _ink = Color(0xFF1B2430);
  static const Color _blueprint = Color(0xFF7B93B5);

  @override
  void render(Canvas canvas) {
    final cx = size.x / 2;
    final glow = 0.30 + 0.55 * _glowT;

    canvas.drawLine(
      Offset(cx - 2, 0),
      Offset(cx - 2, size.y),
      Paint()
        ..color = _ink.withOpacity(glow.clamp(0.0, 1.0))
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(cx + 2, 0),
      Offset(cx + 2, size.y),
      Paint()
        ..color = _ink.withOpacity((glow * 0.6).clamp(0.0, 1.0))
        ..strokeWidth = 1.0
        ..strokeCap = StrokeCap.round,
    );

    final arcRect = Rect.fromCircle(
      center: Offset(cx, size.y * 0.5),
      radius: size.y * 0.38,
    );
    final arcPaint = Paint()
      ..color = _blueprint.withOpacity((0.30 + 0.45 * _glowT).clamp(0.0, 1.0))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    const dashes = 14;
    for (int k = 0; k < dashes; k++) {
      final start = pi / 2 + pi * k / dashes + _time * 0.15 * _glowT;
      canvas.drawArc(arcRect, start, pi / dashes * 0.55, false, arcPaint);
    }

    final dotCount = 24 + (46 * _glowT).round();
    final spread = 3.0 + 11.0 * _glowT;
    final dotPaint = Paint()
      ..color = _ink.withOpacity((0.22 + 0.36 * _glowT).clamp(0.0, 1.0));
    for (int i = 0; i < dotCount; i++) {
      final t = (i + 0.5) / dotCount;
      final y = t * size.y;
      final wobble = sin(_time * (0.7 + (i % 5) * 0.23) + i * 1.7);
      final x = cx + sin(i * 2.399) * spread * (0.5 + 0.5 * wobble.abs());
      canvas.drawCircle(
        Offset(x, y),
        0.7 + (i % 3) * 0.45,
        dotPaint,
      );
    }
  }
}

class ExitDoor extends PositionComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  static const Color _graphite = Color(0xFF3A3A3A);

  final VoidCallback? onEnter;

  ExitDoor({this.onEnter});

  bool isOpen = false;

  double _time = 0.0;
  double _glowT = 0.0;
  bool _entered = false;

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
    if (isOpen) return;
    isOpen = true;
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is CharacterDisplay && isOpen && !_entered && onEnter != null) {
      _entered = true;
      game.player.heal(3);
      game.healthBar?.updateHealth(game.player.hp);
      onEnter!.call();
    }
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
