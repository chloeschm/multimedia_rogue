import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';

class PageScreen extends PositionComponent with HasGameReference<MyGame> {
  late Vector2 paperSize;
  late Vector2 paperPosition;

  @override
  Future<void> onLoad() async {
    size = game.size;
    final bg = SpriteComponent()
      ..sprite = await Sprite.load('background.png')
      ..size = size;
    add(bg);

    paperSize = Vector2(size.x * 0.86, size.y * 0.84);
    paperPosition = Vector2(
      (size.x - paperSize.x) / 2,
      (size.y - paperSize.y) / 2,
    );
    final paper = SpriteComponent()
      ..sprite = await Sprite.load('paper.png')
      ..size = paperSize
      ..position = paperPosition;
    add(paper);
  }
}
