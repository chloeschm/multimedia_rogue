import 'package:flame/components.dart';
import '../mixins/drop_shadow.dart';

class SliderBar extends SpriteComponent with HasDropShadow {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('slider.png');
  }
}
