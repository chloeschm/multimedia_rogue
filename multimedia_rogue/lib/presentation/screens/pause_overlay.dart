import 'dart:ui';
import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/buttons/menu_button.dart';
import 'package:multimedia_rogue/presentation/components/buttons/resume_button.dart';

class PauseOverlay extends PositionComponent with HasGameReference<MyGame> {
  bool _enginePaused = false;

  @override
  void update(double dt) {
    super.update(dt);
    if (!_enginePaused) {
      _enginePaused = true;
      game.pauseEngine();
    }
  }

  @override
  void onRemove() {
    _enginePaused = false;
    game.resumeEngine();
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    size = game.size;

    final background = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0x88000000),
    );
    add(background);

    final resumeButton = ResumeButton();
    resumeButton.size = Vector2(game.size.x * 0.18, game.size.y * 0.12);
    resumeButton.position = Vector2(
      game.size.x / 2 - resumeButton.size.x / 2,
      game.size.y / 2 - resumeButton.size.y / 2,
    );
    add(resumeButton);

    final menuButton = MenuButton(countsDraft: true);
    menuButton.size = Vector2(game.size.x * 0.25, game.size.y * 0.09);
    menuButton.position = Vector2(
      game.size.x - menuButton.size.x - game.size.x * 0.03,
      game.size.y - menuButton.size.y - game.size.y * 0.04,
    );
    add(menuButton);
  }
}
