import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/joysticks/control_style.dart';

class SmudgeJoystick extends PositionComponent
    with DragCallbacks, HasGameReference<MyGame> {
  final void Function(Vector2 direction) onMove;

  SmudgeJoystick({required this.onMove});

  static const int _maxTrailPoints = 10;

  ControlStyle get _style => ControlStyle.of(game.selectedMedium);
  Color get _graphite => _style.color;
  double _blur(double base) => _style.blur(base);

  double _time = 0.0;

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }

  late double _maxRadius;

  final Vector2 _offset = Vector2.zero();

  final Vector2 _rawOffset = Vector2.zero();

  final List<Vector2> _trail = [];

  @override
  Future<void> onLoad() async {
    _maxRadius = size.x * 0.38;
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _rawOffset.setZero();
    _offset.setZero();
    _trail.clear();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    _rawOffset.add(event.localDelta);

    _offset.setFrom(_rawOffset);
    if (_offset.length > _maxRadius) {
      _offset.scaleTo(_maxRadius);
    }

    _trail.add(_offset.clone());
    if (_trail.length > _maxTrailPoints) _trail.removeAt(0);

    onMove(_offset / _maxRadius);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _rawOffset.setZero();
    _offset.setZero();
    _trail.clear();
    onMove(Vector2.zero());
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _rawOffset.setZero();
    _offset.setZero();
    _trail.clear();
    onMove(Vector2.zero());
  }

  @override
  void render(Canvas canvas) {
    final cx = size.x / 2;
    final cy = size.y / 2;
    final center = Offset(cx, cy);
    final knobScale = _style.knobScale;

    canvas.drawCircle(
      center,
      _maxRadius,
      Paint()
        ..color = _graphite.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 * _style.strokeScale,
    );

    for (int i = 0; i < _trail.length; i++) {
      final t = (i + 1) / _trail.length;
      final pos = Offset(cx + _trail[i].x, cy + _trail[i].y);
      final opacity = t * 0.25;
      final spread = 5.0 + (1 - t) * 4;

      canvas.drawOval(
        Rect.fromCenter(
          center: pos,
          width: (20 * t + 8) * knobScale,
          height: (13 * t + 5) * knobScale,
        ),
        Paint()
          ..color = _graphite.withOpacity(opacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, _blur(spread)),
      );
    }

    final knob = Offset(cx + _offset.x, cy + _offset.y);
    for (int layer = 0; layer < 4; layer++) {
      final dx = (layer - 1.5) * 2.5;
      final opacity = 0.55 - layer * 0.10;
      final blur = 3.0 + layer * 1.5;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(knob.dx + dx, knob.dy + 1.0 * layer),
          width: (26 - layer * 2.0) * knobScale,
          height: (17 - layer * 1.5) * knobScale,
        ),
        Paint()
          ..color = _graphite.withOpacity(opacity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, _blur(blur)),
      );
    }

    if (_style.drips) {
      _renderDrips(canvas, knob, knobScale);
    }

    canvas.drawCircle(
      center,
      5 * knobScale,
      Paint()
        ..color = _graphite.withOpacity(0.30)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _blur(2)),
    );
  }

  void _renderDrips(Canvas canvas, Offset knob, double knobScale) {
    for (int i = 0; i < 2; i++) {
      final phase = _time * (0.7 + i * 0.4) + i * 2.1;
      final len = (5.0 + 5.0 * (0.5 + 0.5 * sin(phase))) * knobScale;
      final dx = (i == 0 ? -6.0 : 7.0) * knobScale;
      final top = Offset(knob.dx + dx, knob.dy + 8 * knobScale);
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
}
