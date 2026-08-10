import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/character/character_display.dart';
import 'package:multimedia_rogue/presentation/components/combat/ink_shot.dart';
import 'package:multimedia_rogue/presentation/components/combat/marker_trail.dart';

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

class MarkerExitDoor extends ExitDoor {
  MarkerExitDoor({super.onEnter});

  static const Color _stickerRed = Color(0xFFCE6A50);
  static const Color _outline = Color(0xFF4A3D32);

  @override
  void render(Canvas canvas) {
    final sat = 0.30 + 0.45 * _glowT;
    final wob = sin(_time * 2.2) * 0.012 * _glowT;

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(-0.05 + wob);
    canvas.translate(-size.x / 2, -size.y / 2);

    final door = RRect.fromRectAndRadius(
      Rect.fromLTWH(-size.x * 0.6, size.y * 0.05, size.x * 1.6, size.y * 0.9),
      const Radius.circular(7),
    );

    canvas.drawRRect(
      door.shift(const Offset(4, 5)),
      Paint()..color = _outline.withOpacity(0.22 * sat),
    );
    canvas.drawRRect(
      door.inflate(4),
      Paint()..color = Colors.white.withOpacity(0.55 * sat),
    );
    canvas.drawRRect(
      door,
      Paint()..color = _stickerRed.withOpacity(sat.clamp(0.0, 1.0)),
    );
    canvas.drawRRect(
      door,
      Paint()
        ..color = _outline.withOpacity(sat.clamp(0.0, 1.0))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0,
    );

    canvas.drawCircle(
      Offset(door.left + door.width * 0.25, door.top + door.height * 0.5),
      3.5,
      Paint()..color = _outline.withOpacity(sat.clamp(0.0, 1.0)),
    );

    final peel = Path()
      ..moveTo(door.right, door.top)
      ..lineTo(door.right - 14 - 8 * _glowT, door.top)
      ..lineTo(door.right, door.top + 14 + 8 * _glowT)
      ..close();
    canvas.drawPath(
      peel,
      Paint()..color = Colors.white.withOpacity(0.85 * sat),
    );

    canvas.restore();
  }
}

class WatercolorExitDoor extends ExitDoor {
  WatercolorExitDoor({super.onEnter}) {
    glowRate = 1.1;
  }

  static const Color _washBlue = Color(0xFF4A7BA6);
  static const Color _washViolet = Color(0xFF7E6AA6);

  @override
  void render(Canvas canvas) {
    final cx = size.x / 2;
    final soak = 0.25 + 0.65 * _glowT;

    final archRect = Rect.fromCenter(
      center: Offset(cx, size.y * 0.42),
      width: size.x * 2.2,
      height: size.y * 0.8,
    );
    for (int layer = 0; layer < 3; layer++) {
      canvas.drawArc(
        archRect.inflate(layer * 5.0),
        pi,
        pi,
        false,
        Paint()
          ..color = (layer.isEven ? _washBlue : _washViolet)
              .withOpacity((soak * (0.5 - layer * 0.12)).clamp(0.0, 1.0))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6.0 - layer * 1.5
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0 + layer * 3.0),
      );
    }

    final dripCount = 3 + (5 * _glowT).round();
    for (int i = 0; i < dripCount; i++) {
      final t = (i + 0.5) / dripCount;
      final x = cx + (t - 0.5) * size.x * 2.0;
      final phase = _time * (0.5 + (i % 3) * 0.3) + i * 1.3;
      final len =
          size.y * (0.15 + 0.35 * _glowT) * (0.6 + 0.4 * sin(phase).abs());
      final top = size.y * 0.42;
      canvas.drawLine(
        Offset(x, top),
        Offset(x, top + len),
        Paint()
          ..color = _washBlue.withOpacity((soak * 0.45).clamp(0.0, 1.0))
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
      );
      canvas.drawCircle(
        Offset(x, top + len),
        2.6,
        Paint()
          ..color = _washBlue.withOpacity((soak * 0.55).clamp(0.0, 1.0))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
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

  double glowRate = 5.0;
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
    FlameAudio.play('door.wav');
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
      final screen = (game.characterDisplay as PositionComponent?)?.parent;
      if (screen != null) {
        screen.children
            .whereType<MarkerTrailSegment>()
            .toList()
            .forEach((s) => s.removeFromParent());
        screen.children
            .whereType<InkShot>()
            .toList()
            .forEach((s) => s.removeFromParent());
      }
      FlameAudio.play('flip.wav');
      FlameAudio.play('healthup.wav');
      game.player.heal(3);
      game.healthBar?.updateHealth(game.player.hp);
      game.healthBar?.highlightHeal();
      onEnter!.call();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    final target = isOpen ? 1.0 : 0.0;
    _glowT += (target - _glowT) * (dt * glowRate).clamp(0.0, 1.0);
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
