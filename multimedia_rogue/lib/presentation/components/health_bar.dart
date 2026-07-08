import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';

class HealthBar extends SpriteComponent with HasGameReference<MyGame> {
  final List<Sprite> _sprites = [];

  @override
  Future<void> onLoad() async {
    for (int i = 0; i <= 10; i++) {
      _sprites.add(await Sprite.load('health$i.png'));
    }
    sprite = _sprites[10];
  }

  void updateHealth(int hp) {
    sprite = _sprites[hp.clamp(0, 10)];
  }
}