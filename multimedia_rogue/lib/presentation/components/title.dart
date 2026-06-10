import 'package:flame/components.dart';

class Title extends SpriteComponent {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('title.png');
  }
}