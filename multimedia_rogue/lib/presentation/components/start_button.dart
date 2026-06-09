import 'package:flame/components.dart';
import 'package:flame/events.dart';

class StartButton extends SpriteComponent with TapCallbacks {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('start_button.png');
    size = Vector2(200, 80);
    position = Vector2(100, 150);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // navigate later
  }
}
