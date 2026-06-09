import 'package:flame/components.dart';
import 'package:flame/events.dart';

class CharacterSelect extends SpriteComponent with TapCallbacks {
  late Sprite girlSprite;
  late Sprite boySprite;
  late Sprite androSprite;

  @override
  Future<void> onLoad() async {
    girlSprite = await Sprite.load('girl_character.png'); 
    size = Vector2(400, 300);
    position = Vector2(50, 100);

    boySprite = await Sprite.load('boy_character.png');
    size = Vector2(400, 300);
    position = Vector2(500, 100);

    androSprite = await Sprite.load('andro_character.png');
    size = Vector2(400, 300);
    position = Vector2(950, 100);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // select character later
  }
}
