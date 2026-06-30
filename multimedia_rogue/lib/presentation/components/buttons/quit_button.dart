import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame_audio/flame_audio.dart';
import '../../mixins/drop_shadow.dart';


class QuitButton extends SpriteComponent with TapCallbacks, HasDropShadow {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('quit_button.png');
    paint.colorFilter = null;
  }

  @override
  void onTapDown(TapDownEvent event) {
    FlameAudio.play('womp.m4a');
    paint.colorFilter = ColorFilter.mode(
      Colors.black.withOpacity(0.4),
      BlendMode.darken,
    );
    if (!kIsWeb) SystemNavigator.pop();
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
