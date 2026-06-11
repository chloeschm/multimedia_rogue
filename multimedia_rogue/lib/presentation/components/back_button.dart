import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../mixins/drop_shadow.dart';

class BackButton extends SpriteComponent with TapCallbacks, HasDropShadow {
  final VoidCallback onPressed;

  BackButton({required this.onPressed});

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('back.png');
    paint.colorFilter = null;
  }

  @override
  void onTapDown(TapDownEvent event) {
    paint.colorFilter = ColorFilter.mode(
      Colors.black.withOpacity(0.4),
      BlendMode.darken,
    );
    onPressed();
  }

  @override
  void onTapUp(TapUpEvent event) {
    paint.colorFilter = null;
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    paint.colorFilter = null;
  }
}
