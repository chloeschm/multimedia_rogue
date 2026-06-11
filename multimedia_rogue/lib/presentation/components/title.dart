import 'package:flame/components.dart';
import '../mixins/drop_shadow.dart';

class Title extends SpriteComponent with HasDropShadow {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('title.png');
  }
}