import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:multimedia_rogue/domain/entities/input_action.dart';
import 'package:multimedia_rogue/domain/repositories/input_handler.dart';

class KeyboardAdapter extends Component
    with KeyboardHandler
    implements InputHandler {
  final StreamController<InputAction> _controller =
      StreamController<InputAction>.broadcast();

  final Set<ActionType> _held = {};

  static final Map<ActionType, List<LogicalKeyboardKey>> _bindings = {
    ActionType.moveUp: [LogicalKeyboardKey.keyW, LogicalKeyboardKey.arrowUp],
    ActionType.moveDown: [LogicalKeyboardKey.keyS, LogicalKeyboardKey.arrowDown],
    ActionType.moveLeft: [LogicalKeyboardKey.keyA, LogicalKeyboardKey.arrowLeft],
    ActionType.moveRight: [LogicalKeyboardKey.keyD, LogicalKeyboardKey.arrowRight],
    ActionType.shoot: [LogicalKeyboardKey.space],
  };

  @override
  Stream<InputAction> get inputStream => _controller.stream;

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    for (final binding in _bindings.entries) {
      final isDown = binding.value.any(keysPressed.contains);
      final wasDown = _held.contains(binding.key);
      if (isDown && !wasDown) {
        _held.add(binding.key);
        _controller.add(InputAction(InputPhase.pressed, binding.key));
      } else if (!isDown && wasDown) {
        _held.remove(binding.key);
        _controller.add(InputAction(InputPhase.released, binding.key));
      }
    }
    return false;
  }

  @override
  void onRemove() {
    _controller.close();
    super.onRemove();
  }
}
