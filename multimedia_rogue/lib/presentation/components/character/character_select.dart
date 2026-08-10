import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/main.dart';

class CharacterSelect extends PositionComponent with HasGameReference<MyGame> {
  final List<_CharacterButton> _buttons = [];

  @override
  Future<void> onLoad() async {
    final characterHeight = game.size.y * 0.28;
    final padding = game.size.x * 0.03;

    const files = [
      'girl_character.png',
      'boy_character.png',
      'andro_character.png',
    ];

    var x = 0.0;
    for (final file in files) {
      final sprite = await Sprite.load(file);
      final characterWidth = characterHeight * sprite.srcSize.x / sprite.srcSize.y;
      final button = _CharacterButton(
        spriteFile: file,
        onSelected: _onCharacterSelected,
      )
        ..sprite = sprite
        ..size = Vector2(characterWidth, characterHeight)
        ..position = Vector2(x, 0);
      _buttons.add(button);
      add(button);
      x += characterWidth + padding;
    }

    size = Vector2(x - padding, characterHeight);
  }

  void _onCharacterSelected(_CharacterButton selected) {
    game.selectedCharacter = selected.spriteFile;
    for (final button in _buttons) {
      button.setSelected(button == selected);
    }
  }
}

class _CharacterButton extends SpriteComponent with TapCallbacks {
  final String spriteFile;
  final void Function(_CharacterButton) onSelected;

  _CharacterButton({required this.spriteFile, required this.onSelected});

  @override
  Future<void> onLoad() async {
    sprite ??= await Sprite.load(spriteFile);
  }

  void setSelected(bool selected) {
    paint.colorFilter = selected
        ? ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken)
        : null;
  }

  @override
  void onTapDown(TapDownEvent event) {
    onSelected(this);
  }
}
