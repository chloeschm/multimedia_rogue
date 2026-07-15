import 'dart:async';

import 'package:flame/components.dart';
import 'package:multimedia_rogue/domain/entities/input_action.dart';
import 'package:multimedia_rogue/domain/repositories/input_handler.dart';

class MovementController {
  final Vector2 direction = Vector2.zero();
  double speed = 200.0;
  bool isAttacking = false;

  final Set<ActionType> _held = {};
  final List<StreamSubscription<InputAction>> _subscriptions = [];

  void attach(InputHandler handler) {
    _subscriptions.add(handler.inputStream.listen(_onAction));
  }

  void detachAll() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    _held.clear();
    direction.setZero();
    isAttacking = false;
  }

  void _onAction(InputAction action) {
    switch (action.actionType) {
      case ActionType.move:
        direction.setValues(action.x, action.y);
      case ActionType.moveUp:
      case ActionType.moveDown:
      case ActionType.moveLeft:
      case ActionType.moveRight:
        if (action.phase == InputPhase.pressed) _held.add(action.actionType);
        if (action.phase == InputPhase.released) _held.remove(action.actionType);
        _recomputeDirection();
      case ActionType.shoot:
        isAttacking = action.phase == InputPhase.pressed;
      case ActionType.swapMedium:
        break;
    }
  }

  void _recomputeDirection() {
    final dx = (_held.contains(ActionType.moveRight) ? 1.0 : 0.0) -
        (_held.contains(ActionType.moveLeft) ? 1.0 : 0.0);
    final dy = (_held.contains(ActionType.moveDown) ? 1.0 : 0.0) -
        (_held.contains(ActionType.moveUp) ? 1.0 : 0.0);
    direction.setValues(dx, dy);
    if (direction.length2 > 0) direction.normalize();
  }
}
