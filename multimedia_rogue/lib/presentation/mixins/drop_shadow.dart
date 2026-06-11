import 'package:flame/components.dart';
import 'package:flutter/material.dart';

mixin HasDropShadow on PositionComponent {
@override
void render(Canvas canvas) {
  canvas.drawRect(
    Rect.fromLTWH(4, 4, size.x, size.y),
    Paint()..color = Colors.black.withOpacity(0.3),
  );
  super.render(canvas); 
}
}