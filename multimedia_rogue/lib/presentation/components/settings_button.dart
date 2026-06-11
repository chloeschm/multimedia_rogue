import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../mixins/drop_shadow.dart';

class SettingsButton extends SpriteComponent with TapCallbacks, HasDropShadow {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('settings_button.png'); 
  }

  @override
  void onTapDown(TapDownEvent event) {
    // navigate to settings later
  }
}