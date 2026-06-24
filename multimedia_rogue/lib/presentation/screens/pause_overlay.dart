import 'dart:ui';
import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/menu_button.dart';

class PauseOverlay extends PositionComponent with HasGameReference<MyGame> {
  @override
  Future<void> onLoad() async {
    size = game.size;

    final background = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0x88000000),
    );
    add(background);

    final menuButton = MenuButton();
    menuButton.size = Vector2(game.size.x * 0.25, game.size.y * 0.09);
    menuButton.position = Vector2(
      game.size.x / 2 - menuButton.size.x / 2,
      game.size.y / 2 - menuButton.size.y / 2,
    );
    add(menuButton);
  }
}
