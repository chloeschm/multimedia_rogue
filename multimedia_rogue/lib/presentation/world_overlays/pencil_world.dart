import 'dart:ui';
import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/enemy/pencil_enemy.dart';

class PencilWorld extends PositionComponent with HasGameReference<MyGame> {
  @override
  Future<void> onLoad() async {
    size = game.size;
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFFFFFFFF),
    ));
    add(PencilEnemyDisplay());
  }
}
