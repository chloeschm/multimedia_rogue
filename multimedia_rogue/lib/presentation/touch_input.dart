import 'dart:async';

import 'package:multimedia_rogue/domain/entities/input_action.dart';
import 'package:multimedia_rogue/domain/repositories/input_handler.dart';

class TouchInput implements InputHandler {
  final StreamController<InputAction> _controller = StreamController<InputAction>();

  @override
  Stream<InputAction> get inputStream => _controller.stream;

  void onTap() {
    _controller.add(InputAction(InputPhase.pressed, ActionType.shoot));
  }

  void onJoystickUp() {
    _controller.add(InputAction(InputPhase.pressed, ActionType.moveUp));
  }

  void onJoystickDown() {
    _controller.add(InputAction(InputPhase.pressed, ActionType.moveDown));
  }

  void onJoystickLeft() {
    _controller.add(InputAction(InputPhase.pressed, ActionType.moveLeft));
  }

  void onJoystickRight() {
    _controller.add(InputAction(InputPhase.pressed, ActionType.moveRight));
  }

  void onDoubleTap() {
    _controller.add(InputAction(InputPhase.pressed, ActionType.swapMedium));
  }

  void dispose() {
    _controller.close();
  }
}