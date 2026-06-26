import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:multimedia_rogue/main.dart';

class KeyboardAdapter extends Component
    with KeyboardHandler, HasGameReference<MyGame> {
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final dir = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) dir.y -= 1;
    if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) dir.y += 1;
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) dir.x -= 1;
    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) dir.x += 1;

    if (dir.length > 0) dir.normalize();
    game.movementController.direction.setFrom(dir);

    return false; 
  }
}
