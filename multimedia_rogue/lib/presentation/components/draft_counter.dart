import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:multimedia_rogue/main.dart';
import '../mixins/drop_shadow.dart';


class DraftCounter extends PositionComponent with HasGameReference<MyGame>, HasDropShadow {
  late SpriteComponent _labelSprite;
  late SpriteComponent _digitSprite;
  late ui.Image _spriteSheetImage;

  int currentDraft = 0;

  @override
  Future<void> onLoad() async {
    final sheetImage = await Flame.images.load('draft_counter_sheet.png');
    _spriteSheetImage = sheetImage;
    _labelSprite = SpriteComponent(
      sprite: await Sprite.load('draft_counter.png'),
      size: Vector2(game.size.x * 0.12, game.size.y * 0.06),
    );

    _digitSprite = SpriteComponent(
      sprite: _getSpriteForDigit(currentDraft),
      size: Vector2(game.size.x * 0.05, game.size.y * 0.06),
      position: Vector2(_labelSprite.size.x + 5, 0),
    );

    add(_labelSprite);
    add(_digitSprite);
  }

  Sprite _getSpriteForDigit(int digit) {
    const frameHeight = 667.0;
    const frameWidth = 350.0;

    const List<double> xPositions = [
      20, // 1
      430, // 2
      820, // 3
      1210, // 4
      1600, // 5
      1990, // 6
      2380, // 7
      2770, // 8
      3160, // 9
      3580, // 0
    ];

    final int index = digit == 0 ? 9 : digit - 1;
    return Sprite(
      _spriteSheetImage,
      srcPosition: Vector2(xPositions[index], 0),
      srcSize: Vector2(frameWidth, frameHeight),
    );
  }
}
