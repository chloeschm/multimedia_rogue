enum ActionType {
  swapMedium, shoot, moveUp, moveDown, moveLeft, moveRight, move,
}

enum InputPhase {
  none, pressed, released
}

class InputAction {
  final InputPhase phase;
  final ActionType actionType;

  final double x;
  final double y;

  InputAction(this.phase, this.actionType, {this.x = 0, this.y = 0});
}
