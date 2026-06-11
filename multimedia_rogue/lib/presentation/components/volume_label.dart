import 'package:flame/components.dart';
import '../mixins/drop_shadow.dart';

class VolumeLabel extends SpriteComponent with HasDropShadow {
  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('volume.png');
  }
}
