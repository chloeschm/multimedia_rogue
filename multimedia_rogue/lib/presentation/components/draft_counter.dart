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
  void onMount() {
    super.onMount();
    currentDraft = game.draftCount;
    _digitSprite.sprite = _getSpriteForDigit(currentDraft % 10);
  }

  @override
  Future<void> onLoad() async {
    currentDraft = game.draftCount;
    final sheetImage = await Flame.images.load('draft_counter_sheet.png');
    _spriteSheetImage = sheetImage;
    _labelSprite = SpriteComponent(
      sprite: await Sprite.load('draft_counter.png'),
      size: Vector2(game.size.x * 0.12, game.size.y * 0.06),
    );

    _digitSprite = SpriteComponent(
      sprite: _getSpriteForDigit(currentDraft % 10),
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
      20,
      430,
      820,
      1210,
      1600,
      1990,
      2380,
      2770,
      3160,
      3580,
    ];

    final int index = digit == 0 ? 9 : digit - 1;
    return Sprite(
      _spriteSheetImage,
      srcPosition: Vector2(xPositions[index], 0),
      srcSize: Vector2(frameWidth, frameHeight),
    );
  }
}
