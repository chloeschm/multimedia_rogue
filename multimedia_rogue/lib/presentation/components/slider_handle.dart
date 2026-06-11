import 'package:flame/components.dart';
import 'package:flame/events.dart';

class SliderHandle extends SpriteComponent with DragCallbacks {
  final double sliderLeft;
  final double sliderRight;

  SliderHandle({required this.sliderLeft, required this.sliderRight});

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('circle.png');
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final newX = (position.x + event.localEndPosition.x).clamp(
      sliderLeft - size.x / 2,
      sliderRight - size.x / 2,
    );
    position.x = newX;
  }
}
