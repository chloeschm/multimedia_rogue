import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:multimedia_rogue/main.dart';

class CharacterSelect extends PositionComponent with HasGameReference<MyGame>, TapCallbacks {
  @override
  Future<void> onLoad() async {
    final characterWidth = game.size.x * 0.15;
    final characterHeight = game.size.y * 0.25;
    final padding = game.size.x * 0.05;
    final totalWidth = (characterWidth * 3) + (padding * 2);

    size = Vector2(totalWidth, characterHeight);

    final girl = SpriteComponent()
      ..sprite = await Sprite.load('girl_character.png')
      ..size = Vector2(characterWidth, characterHeight)
      ..position = Vector2(0, 0);

    final boy = SpriteComponent()
      ..sprite = await Sprite.load('boy_character.png')
      ..size = Vector2(characterWidth, characterHeight)
      ..position = Vector2(characterWidth + padding, 0);

    final andro = SpriteComponent()
      ..sprite = await Sprite.load('andro_character.png')
      ..size = Vector2(characterWidth, characterHeight)
      ..position = Vector2((characterWidth + padding) * 2, 0);

    addAll([girl, boy, andro]);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // select character later
  }
}
