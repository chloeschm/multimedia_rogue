import 'package:flame/components.dart';
import 'package:flame/events.dart';

class QuitButton extends SpriteComponent with TapCallbacks {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('quit_button.png'); 
    size = Vector2(200, 80);
    position = Vector2(100, 350);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // quit game later
  }
}
