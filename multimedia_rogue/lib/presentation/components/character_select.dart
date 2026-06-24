import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/main.dart';

class CharacterSelect extends PositionComponent with HasGameReference<MyGame> {
  final List<_CharacterButton> _buttons = [];

  @override
  Future<void> onLoad() async {
    final characterWidth = game.size.x * 0.15;
    final characterHeight = game.size.y * 0.25;
    final padding = game.size.x * 0.05;
    final totalWidth = (characterWidth * 3) + (padding * 2);

    size = Vector2(totalWidth, characterHeight);

    final configs = [
      ('girl_character.png', Vector2(0, 0)),
      ('boy_character.png', Vector2(characterWidth + padding, 0)),
      ('andro_character.png', Vector2((characterWidth + padding) * 2, 0)),
    ];

    for (final (file, pos) in configs) {
      final button = _CharacterButton(
        spriteFile: file,
        onSelected: _onCharacterSelected,
      )
        ..size = Vector2(characterWidth, characterHeight)
        ..position = pos;
      _buttons.add(button);
      add(button);
    }
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
    sprite = await Sprite.load(spriteFile);
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
