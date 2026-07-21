import 'dart:ui';
import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/enemy/pencil_enemy.dart';
import 'package:multimedia_rogue/presentation/components/exit_door.dart';
import 'package:multimedia_rogue/presentation/world_overlays/pen_world.dart';

class PencilWorld extends PositionComponent with HasGameReference<MyGame> {
  @override
  Future<void> onLoad() async {
    size = game.size;
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFFFFFFFF),
    ));
    add(PencilEnemyDisplay());

    final door = ExitDoor(onEnter: _enterPenWorld)
      ..size = Vector2(game.size.x * 0.025, game.size.y * 0.3)
      ..position = Vector2(game.size.x * 0.975, game.size.y * 0.35);
    add(door);
  }

  void _enterPenWorld() {
    final screen = parent;
    if (screen == null) return;
    (game.characterDisplay as PositionComponent?)?.position = Vector2(
      game.size.x * 0.08,
      game.size.y * 0.55,
    );
    screen.add(PenWorld());
    removeFromParent();
  }
}
