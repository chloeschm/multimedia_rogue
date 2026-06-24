import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/main.dart';
import '../mixins/drop_shadow.dart';

class MenuButton extends SpriteComponent
    with TapCallbacks, HasDropShadow, HasGameReference<MyGame> {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('menu.png');
    paint.colorFilter = null;
  }

  @override
  void onTapDown(TapDownEvent event) {
    paint.colorFilter = ColorFilter.mode(
      Colors.black.withOpacity(0.4),
      BlendMode.darken,
    );
    game.router.pop(); // close pause
    game.router.pop(); // close game, back to start
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
