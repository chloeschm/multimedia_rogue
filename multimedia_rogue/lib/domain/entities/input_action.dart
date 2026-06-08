enum ActionType {
  swapMedium, shoot, moveUp, moveDown, moveLeft, moveRight
}

enum InputPhase {
  none, pressed, released
}

class InputAction {
  final InputPhase phase;
  final ActionType actionType;

  InputAction(this.phase, this.actionType);
}