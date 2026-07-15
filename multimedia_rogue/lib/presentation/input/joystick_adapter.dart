import 'dart:async';

import 'package:flame/components.dart';
import 'package:multimedia_rogue/domain/entities/input_action.dart';
import 'package:multimedia_rogue/domain/repositories/input_handler.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/buttons/smudge_shoot_button.dart';
import 'package:multimedia_rogue/presentation/components/joysticks/smudge_joystick.dart';

class JoystickAdapter extends Component
    with HasGameReference<MyGame>
    implements InputHandler {
  final StreamController<InputAction> _controller =
      StreamController<InputAction>.broadcast();

  @override
  Stream<InputAction> get inputStream => _controller.stream;

  @override
  Future<void> onLoad() async {
    final joySize = game.size.x * 0.17;

    final joystick = SmudgeJoystick(onMove: _emitMove)
      ..size = Vector2.all(joySize)
      ..position = Vector2(
        game.size.x * 0.02,
        game.size.y - joySize - game.size.y * 0.03,
      );

    add(joystick);

    final shootButton = SmudgeShootButton(onShoot: _emitShoot)
      ..size = Vector2.all(joySize)
      ..position = Vector2(
        game.size.x - joySize - game.size.x * 0.02,
        game.size.y - joySize - game.size.y * 0.03,
      );

    add(shootButton);
  }

  void _emitShoot(bool pressed) {
    _controller.add(
      InputAction(
        pressed ? InputPhase.pressed : InputPhase.released,
        ActionType.shoot,
      ),
    );
  }

  void _emitMove(Vector2 dir) {
    _controller.add(
      InputAction(
        dir.length2 > 0 ? InputPhase.pressed : InputPhase.released,
        ActionType.move,
        x: dir.x,
        y: dir.y,
      ),
    );
  }

  @override
  void onRemove() {
    _controller.close();
    super.onRemove();
  }
}
