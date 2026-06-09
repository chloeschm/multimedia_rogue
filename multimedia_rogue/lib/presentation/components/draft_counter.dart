import 'dart:ui' as ui;

import 'package:flame/components.dart';

class DraftCounter extends SpriteComponent {
  late ui.Image spriteSheet;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('draft_counter_sheet.png');
    size = Vector2(200, 80);
    position = Vector2(100, 450);
  }
}
