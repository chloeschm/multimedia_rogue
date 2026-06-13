import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/painting.dart';
import 'package:multimedia_rogue/main.dart';

class WeaponSlots extends PositionComponent with HasGameReference<MyGame> {
  final List<_WeaponSlot> _slots = [];

  @override
  Future<void> onLoad() async {
    final slotWidth = game.size.x * 0.1;
    final slotHeight = game.size.y * 0.1;
    final padding = game.size.x * 0.02;
    size = Vector2((slotWidth * 6) + (padding * 5), slotHeight);

    final slotFiles = [
      'pencil.png',
      'pen.png',
      'marker.png',
      'brush.png',
      'watercolor.png',
      'pastel.png',
    ];

    for (int i = 0; i < slotFiles.length; i++) {
      final slot = _WeaponSlot(
        spriteFile: slotFiles[i],
        position: Vector2(i * (slotWidth + padding), 0),
        size: Vector2(slotWidth, slotHeight),
      );
      _slots.add(slot);
      add(slot);
    }
  }

  void unlockSlot(int index) {
    if (index >= 0 && index < _slots.length) {
      _slots[index].unlock();
    }
  }
}

class _WeaponSlot extends SpriteComponent with TapCallbacks {
  final String spriteFile;
  bool isLocked = true;

  _WeaponSlot({
    required this.spriteFile,
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(spriteFile);
    _applyLockedState();
  }

  void unlock() {
    isLocked = false;
    _applyLockedState();
  }

  void _applyLockedState() {
    paint = Paint()
      ..color = isLocked
          ? const Color.fromARGB(255, 90, 90, 90).withValues(alpha: 0.5)
          : const Color(0xFFFFFFFF);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!isLocked) {
      // swap medium later
    }
  }
}
