import 'package:flame/components.dart';
import 'package:flame/events.dart';

class SettingsButton extends SpriteComponent with TapCallbacks {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('settings_button.png'); 
    size = Vector2(200, 80);
    position = Vector2(100, 250);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // navigate to settings later
  }
}