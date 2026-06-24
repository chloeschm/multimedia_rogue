import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/main.dart';

class ResumeButton extends PositionComponent
    with TapCallbacks, HasGameReference<MyGame> {
  bool _pressed = false;

  @override
  Future<void> onLoad() async {}

  @override
  void render(Canvas canvas) {
    final opacity = _pressed ? 0.5 : 1.0;
    final paint = Paint()..color = Colors.white.withOpacity(opacity);

    final barWidth = size.x * 0.3;
    final barHeight = size.y;
    final gap = size.x * 0.2;
    final startX = (size.x - barWidth * 2 - gap) / 2;

    final shadowPaint = Paint()..color = Colors.black.withOpacity(0.3);
    canvas.drawRect(Rect.fromLTWH(startX + 4, 4, barWidth, barHeight), shadowPaint);
    canvas.drawRect(Rect.fromLTWH(startX + barWidth + gap + 4, 4, barWidth, barHeight), shadowPaint);

    canvas.drawRect(Rect.fromLTWH(startX, 0, barWidth, barHeight), paint);
    canvas.drawRect(Rect.fromLTWH(startX + barWidth + gap, 0, barWidth, barHeight), paint);

    super.render(canvas);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _pressed = true;
    game.router.pop();
  }

  @override
  void onTapUp(TapUpEvent event) {
    _pressed = false;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _pressed = false;
  }
}
