import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/joysticks/control_style.dart';

class SmudgeShootButton extends PositionComponent
    with TapCallbacks, DragCallbacks, HasGameReference<MyGame> {
  final void Function(bool pressed) onShoot;

  SmudgeShootButton({required this.onShoot});

  ControlStyle get _style => ControlStyle.of(game.selectedMedium);
  Color get _graphite => _style.color;
  double _blur(double base) => _style.blur(base);

  double _time = 0.0;

  bool _pressed = false;
  bool _dragging = false;
  double _pressT = 0.0;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    _pressed = value;
    onShoot(value);
  }

  @override
  void onTapDown(TapDownEvent event) => _setPressed(true);

  @override
  void onTapUp(TapUpEvent event) => _setPressed(false);

  @override
  void onTapCancel(TapCancelEvent event) {
    if (!_dragging) _setPressed(false);
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _dragging = true;
    _setPressed(true);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _dragging = false;
    _setPressed(false);
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _dragging = false;
    _setPressed(false);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
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
        ..strokeWidth = 1.2 * _style.strokeScale,
    );

 
    final coreW = radius * 1.15 * (1.0 - 0.08 * _pressT) * _style.knobScale;
    final coreH = radius * 0.78 * (1.0 - 0.08 * _pressT) * _style.knobScale;
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
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, _blur(blur)),
      );
    }

    if (_style.drips) {
      for (int i = 0; i < 2; i++) {
        final phase = _time * (0.7 + i * 0.4) + i * 2.1;
        final len = 5.0 + 5.0 * (0.5 + 0.5 * sin(phase));
        final dx = i == 0 ? -coreW * 0.22 : coreW * 0.28;
        final top = Offset(center.dx + dx, center.dy + coreH * 0.42);
        canvas.drawLine(
          top,
          top.translate(0, len),
          Paint()
            ..color = _graphite.withOpacity(0.22)
            ..strokeWidth = 2.0
            ..strokeCap = StrokeCap.round
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
        );
        canvas.drawCircle(
          top.translate(0, len),
          2.2,
          Paint()
            ..color = _graphite.withOpacity(0.32)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0),
        );
      }
    }

    canvas.drawCircle(
      center,
      (4.5 + 1.5 * _pressT) * _style.knobScale,
      Paint()
        ..color = _graphite.withOpacity(0.30 + 0.25 * _pressT)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _blur(2)),
    );
  }
}
