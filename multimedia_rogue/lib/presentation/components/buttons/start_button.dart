import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:multimedia_rogue/main.dart';
import '../../mixins/drop_shadow.dart';

class StartButton extends SpriteComponent
    with TapCallbacks, HasDropShadow, HasGameReference<MyGame> {
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
    Future.delayed(const Duration(milliseconds: 1000), () {
      game.router.pushReplacementNamed('game');
    });
  }

  @override
  void onTapUp(TapUpEvent event) {
    sprite = _normalSprite;
  }
}
