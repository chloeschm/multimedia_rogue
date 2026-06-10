import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';

class StartButton extends SpriteComponent with TapCallbacks {
  late Sprite _pressedSprite;
  late Sprite _normalSprite;

  @override
  Future<void> onLoad() async {
    _pressedSprite = await Sprite.load('start_pressed.jpg');
    _normalSprite = await Sprite.load('start_button.png');

    sprite = _normalSprite;
  }

  @override
  void onTapDown(TapDownEvent event) {
    sprite = _pressedSprite;
    FlameAudio.play('stamp.m4a');
  }

  @override
  void onTapUp(TapUpEvent event) {
    sprite = _normalSprite;
  }
}
