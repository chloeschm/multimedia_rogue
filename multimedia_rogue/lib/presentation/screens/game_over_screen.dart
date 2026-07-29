import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/buttons/menu_button.dart';

class GameOverScreen extends PositionComponent with HasGameReference<MyGame> {
  @override
  Future<void> onLoad() async {
    size = game.size;
    game.draftCount++;

    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = const Color(0xE61B2430),
      ),
    );

    final paper = SpriteComponent(
      sprite: await Sprite.load('paper.png'),
      size: Vector2(game.size.x * 0.5, game.size.y * 0.66),
      anchor: Anchor.center,
      position: Vector2(game.size.x / 2, game.size.y / 2),
    );
    add(paper);

    add(
      TextComponent(
        text: 'GAME OVER',
        anchor: Anchor.center,
        position: Vector2(game.size.x / 2, game.size.y * 0.38),
        textRenderer: TextPaint(
          style: TextStyle(
            color: const Color(0xFF3A3A3A),
            fontSize: game.size.y * 0.08,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
    );

    add(
      TextComponent(
        text: 'draft #${game.draftCount} scrapped',
        anchor: Anchor.center,
        position: Vector2(game.size.x / 2, game.size.y * 0.49),
        textRenderer: TextPaint(
          style: TextStyle(
            color: const Color(0xFF3A3A3A),
            fontSize: game.size.y * 0.035,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );

    final menuButton = MenuButton()
      ..size = Vector2(game.size.x * 0.25, game.size.y * 0.09)
      ..position = Vector2(
        game.size.x / 2 - game.size.x * 0.125,
        game.size.y * 0.56,
      );
    add(menuButton);
  }
}
