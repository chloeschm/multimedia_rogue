import 'package:flame/components.dart';
import 'package:flame/events.dart';

class StartButton extends SpriteComponent with TapCallbacks {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('start_button.png');
  }

  @override
  void onTapDown(TapDownEvent event) {
    // navigate later
  }
}
