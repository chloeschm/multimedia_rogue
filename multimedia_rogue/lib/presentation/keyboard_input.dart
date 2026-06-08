import 'dart:async';

import 'package:flutter/services.dart';
import 'package:multimedia_rogue/domain/entities/input_action.dart';
import 'package:multimedia_rogue/domain/repositories/input_handler.dart';

class KeyboardInput implements InputHandler {
  final StreamController<InputAction> _controller = StreamController<InputAction>();

  KeyboardInput() {
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  @override
  Stream<InputAction> get inputStream => _controller.stream;

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _controller.add(InputAction(InputPhase.pressed, ActionType.moveUp));
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _controller.add(InputAction(InputPhase.pressed, ActionType.moveDown));
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _controller.add(InputAction(InputPhase.pressed, ActionType.moveLeft));
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _controller.add(InputAction(InputPhase.pressed, ActionType.moveRight));
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        _controller.add(InputAction(InputPhase.pressed, ActionType.shoot));
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
        _controller.add(InputAction(InputPhase.pressed, ActionType.swapMedium));
        return true;
      }
    }
    return false;
  }
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
    _controller.close();
  }
}
