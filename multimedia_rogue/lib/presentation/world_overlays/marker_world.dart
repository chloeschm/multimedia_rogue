import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/enemy/marker_enemy.dart';
import 'package:multimedia_rogue/presentation/components/exit_door.dart';
import 'package:multimedia_rogue/presentation/world_overlays/watercolor_world.dart';

class MarkerWorld extends PositionComponent with HasGameReference<MyGame> {
  MarkerWorld() : super(priority: -10);

  @override
  Future<void> onLoad() async {
    size = game.size;
    add(_ConstructionPaperBackground()..size = size);
    add(MarkerEnemyDisplay());

    final door = MarkerExitDoor(onEnter: _enterWatercolorWorld)
      ..size = Vector2(game.size.x * 0.025, game.size.y * 0.3)
      ..position = Vector2(game.size.x * 0.965, game.size.y * 0.35);
    add(door);
  }

  void _enterWatercolorWorld() {
    final screen = parent;
    if (screen == null) return;
    (game.characterDisplay as PositionComponent?)?.position = Vector2(
      game.size.x * 0.08,
      game.size.y * 0.55,
    );
    screen.add(WatercolorWorld());
    removeFromParent();
  }
}

class _ConstructionPaperBackground extends PositionComponent {
  static const Color _paper = Color(0xFFF2E2B8);
  static const List<Color> _fields = [
    Color(0xFFE0452C),
    Color(0xFF2C7FE0),
    Color(0xFF2CA05A),
    Color(0xFF8A4FC8),
    Color(0xFFE07A2C),
  ];

  final List<_ColorField> _shapes = [];

  @override
  Future<void> onLoad() async {
    final random = Random(11);
    for (int i = 0; i < 7; i++) {
      _shapes.add(
        _ColorField(
          color: _fields[i % _fields.length],
          rect: Rect.fromCenter(
            center: Offset(
              random.nextDouble() * size.x,
              random.nextDouble() * size.y,
            ),
            width: size.x * (0.18 + random.nextDouble() * 0.22),
            height: size.y * (0.18 + random.nextDouble() * 0.25),
          ),
          rotation: (random.nextDouble() - 0.5) * 0.35,
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = _paper,
    );

    for (final shape in _shapes) {
      canvas.save();
      canvas.translate(shape.rect.center.dx, shape.rect.center.dy);
      canvas.rotate(shape.rotation);
      canvas.translate(-shape.rect.center.dx, -shape.rect.center.dy);
      canvas.drawRRect(
        RRect.fromRectAndRadius(shape.rect, const Radius.circular(18)),
        Paint()..color = shape.color.withOpacity(0.14),
      );
      canvas.restore();
    }
  }
}

class _ColorField {
  final Color color;
  final Rect rect;
  final double rotation;

  _ColorField({required this.color, required this.rect, required this.rotation});
}
