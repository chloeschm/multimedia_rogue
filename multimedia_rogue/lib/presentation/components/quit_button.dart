import 'package:flame/components.dart';
import 'package:flame/events.dart';

class QuitButton extends SpriteComponent with TapCallbacks {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('quit_button.png'); 
  }

  @override
  void onTapDown(TapDownEvent event) {
    // quit game later
  }
}
