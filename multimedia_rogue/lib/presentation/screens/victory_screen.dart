import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/data/medium_weapon_assets.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/buttons/menu_button.dart';

class VictoryScreen extends PositionComponent with HasGameReference<MyGame> {
  static const List<MediumType> _displayOrder = [
    MediumType.pencil,
    MediumType.pen,
    MediumType.marker,
    MediumType.watercolor,
  ];

  @override
  Future<void> onLoad() async {
    size = game.size;
    game.draftCount++;
    FlameAudio.play('hooray.wav');

    add(
      SpriteComponent(sprite: await Sprite.load('background.png'), size: size),
    );
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = const Color(0x334A7BA6),
      ),
    );

    await _addTitle();

    final frameWidth = game.size.x * 0.42;
    final frameHeight = frameWidth * 285 / 433;
    final frameCenter = Vector2(game.size.x / 2, game.size.y * 0.52);

    add(
      SpriteComponent(
        sprite: await Sprite.load('frame.png'),
        size: Vector2(frameWidth, frameHeight),
        anchor: Anchor.center,
        position: frameCenter,
      ),
    );

    add(
      TextComponent(
        text: 'draft #${game.draftCount}',
        anchor: Anchor.center,
        position: Vector2(frameCenter.x, frameCenter.y - frameHeight * 0.10),
        textRenderer: TextPaint(
          style: TextStyle(
            color: const Color(0xFF3A3A3A),
            fontSize: game.size.y * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final unlocked =
        _displayOrder.where(game.unlockedMediums.contains).toList();
    final iconSize = game.size.x * 0.045;
    final spacing = iconSize * 1.3;
    final startX = frameCenter.x - spacing * (unlocked.length - 1) / 2;
    for (int i = 0; i < unlocked.length; i++) {
      final asset = mediumWeaponAssets[unlocked[i]];
      if (asset == null) continue;
      add(
        SpriteComponent(
          sprite: await Sprite.load(asset.spritePath),
          size: Vector2.all(iconSize),
          anchor: Anchor.center,
          position: Vector2(
            startX + i * spacing,
            frameCenter.y + frameHeight * 0.12,
          ),
        ),
      );
    }

    final menuButton = MenuButton()
      ..size = Vector2(game.size.x * 0.25, game.size.y * 0.09)
      ..position = Vector2(
        game.size.x / 2 - game.size.x * 0.125,
        game.size.y * 0.80,
      );
    add(menuButton);
  }

  Future<void> _addTitle() async {
    Sprite? title;
    for (final file in ['masterpiece.png', 'masterpiece.jpg']) {
      try {
        title = await Sprite.load(file);
        break;
      } catch (_) {}
    }

    if (title != null) {
      final w = game.size.x * 0.42;
      final h = w * title.srcSize.y / title.srcSize.x;
      add(
        SpriteComponent(
          sprite: title,
          size: Vector2(w, h),
          anchor: Anchor.center,
          position: Vector2(game.size.x / 2, game.size.y * 0.15),
        ),
      );
    } else {
      add(
        TextComponent(
          text: 'MASTERPIECE',
          anchor: Anchor.center,
          position: Vector2(game.size.x / 2, game.size.y * 0.15),
          textRenderer: TextPaint(
            style: TextStyle(
              color: Colors.white,
              fontSize: game.size.y * 0.07,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
        ),
      );
    }
  }
}
