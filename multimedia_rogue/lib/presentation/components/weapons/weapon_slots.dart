import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/character/character_display.dart';

class WeaponSlots extends PositionComponent with HasGameReference<MyGame> {
  final List<_WeaponSlot> _slots = [];
  int _selectedIndex = 0;

  static const List<MediumType> _slotMediums = [
    MediumType.pencil,
    MediumType.pen,
    MediumType.marker,
    MediumType.watercolor,
    // MediumType.brush,
    // MediumType.pastel,
  ];

  @override
  void onMount() {
    super.onMount();
    game.weaponSlots = this;
  }

  @override
  void onRemove() {
    if (game.weaponSlots == this) game.weaponSlots = null;
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    final slotFiles = [
      'pencil.png',
      'pen.png',
      'marker.png',
      'watercolor.png',
      // 'brush.png',
      // 'pastel.png',
    ];

    final slotWidth = game.size.x * 0.09;
    final slotHeight = game.size.y * 0.09;
    final padding = game.size.x * 0.01;
    size = Vector2(
      (slotWidth * slotFiles.length) + (padding * (slotFiles.length - 1)),
      slotHeight,
    );

    for (int i = 0; i < slotFiles.length; i++) {
      final slot = _WeaponSlot(
        spriteFile: slotFiles[i],
        position: Vector2(i * (slotWidth + padding), 0),
        size: Vector2(slotWidth, slotHeight),
        onTap: () => _selectSlot(i),
      );
      _slots.add(slot);
      add(slot);
    }

    for (final medium in game.unlockedMediums) {
      final index = _slotMediums.indexOf(medium);
      if (index >= 0) _slots[index].unlock();
    }
    _slots[0].select();
    game.selectedMedium = _slotMediums[0];
  }

  void _selectSlot(int index) {
    if (index < 0 || index >= _slots.length) return;
    if (_slots[index].isLocked) return;
    if (index == _selectedIndex) return;
    _slots[_selectedIndex].deselect();
    _selectedIndex = index;
    _slots[_selectedIndex].select();
    game.selectedMedium = _slotMediums[index];

    (game.characterDisplay as CharacterDisplay?)?.refreshMedium();
  }

  void unlockSlot(int index) {
    if (index >= 0 && index < _slots.length) {
      _slots[index].unlock();
      game.unlockedMediums.add(_slotMediums[index]);
    }
  }

  void unlockMedium(MediumType medium) {
    unlockSlot(_slotMediums.indexOf(medium));
  }

  void selectMedium(MediumType medium) {
    _selectSlot(_slotMediums.indexOf(medium));
  }
}

class _WeaponSlot extends SpriteComponent with TapCallbacks {
  final String spriteFile;
  final VoidCallback onTap;
  bool isLocked = true;
  bool isSelected = false;

  _WeaponSlot({
    required this.spriteFile,
    required Vector2 position,
    required Vector2 size,
    required this.onTap,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(spriteFile);
    _applyState();
  }

  void unlock() {
    isLocked = false;
    _applyState();
  }

  void select() {
    isSelected = true;
    _applyState();
  }

  void deselect() {
    isSelected = false;
    _applyState();
  }

  void _applyState() {
    if (isLocked) {
      paint = Paint()
        ..colorFilter = const ColorFilter.mode(
          Color(0xFF888888),
          BlendMode.multiply,
        )
        ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.45);
    } else if (isSelected) {
      paint = Paint()..color = const Color(0xFFFFFFFF);
    } else {
      paint = Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: 0.65);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!isLocked) onTap();
  }
}
