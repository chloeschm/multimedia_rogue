import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/joysticks/smudge_joystick.dart';

class JoystickAdapter extends Component with HasGameReference<MyGame> {
  @override
  Future<void> onLoad() async {
    final joySize = game.size.x * 0.17;

    final joystick = SmudgeJoystick()
      ..size = Vector2.all(joySize)
      ..position = Vector2(
        game.size.x * 0.02,
        game.size.y - joySize - game.size.y * 0.03,
      );

    add(joystick);
  }
}
