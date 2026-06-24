import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';
import '../mixins/drop_shadow.dart';

class CharacterDisplay extends PositionComponent with HasGameReference<MyGame> {
  _CharacterSprite? _sprite;

  @override
  void onMount() {
    super.onMount();
    _refresh();
  }

  void _refresh() async {
    final file = game.selectedCharacter;
    if (file == null) return;

    _sprite?.removeFromParent();

    final w = game.size.x * 0.15;
    final h = game.size.y * 0.3;

    _sprite = _CharacterSprite()
      ..sprite = await Sprite.load(file)
      ..size = Vector2(w, h)
      ..position = Vector2(
        game.size.x * 0.05,
        game.size.y * 0.55,
      );

    add(_sprite!);
  }
}

class _CharacterSprite extends SpriteComponent with HasDropShadow {}
