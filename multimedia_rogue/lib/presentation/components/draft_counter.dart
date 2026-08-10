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

    const List<double> srcX = [
      0,
      228,
      650,
      1089,
      1516,
      1958,
      2359,
      2766,
      3214,
      3608,
    ];
    const List<double> srcWidth = [
      228,
      398,
      400,
      400,
      400,
      393,
      390,
      400,
      389,
      400,
    ];

    final int index = digit == 0 ? 9 : digit - 1;
    return Sprite(
      _spriteSheetImage,
      srcPosition: Vector2(srcX[index], 0),
      srcSize: Vector2(srcWidth[index], frameHeight),
    );
  }
}
