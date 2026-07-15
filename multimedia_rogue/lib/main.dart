import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/domain/entities/player_health.dart';
import 'package:multimedia_rogue/presentation/components/health_bar.dart';
import 'package:multimedia_rogue/presentation/input/movement_controller.dart';
import 'package:multimedia_rogue/presentation/screens/game_screen.dart';
import 'package:multimedia_rogue/presentation/screens/pause_overlay.dart';
import 'package:multimedia_rogue/presentation/screens/start_screen.dart';
import 'package:multimedia_rogue/presentation/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  final game = MyGame();
  runApp(GameWidget(game: game));
}

class MyGame extends FlameGame
    with
        HasCollisionDetection,
        HasGameReference<MyGame>,
        HasKeyboardHandlerComponents
        {
  late final RouterComponent router;
  final PlayerHealth player = PlayerHealth();
  final MovementController movementController = MovementController();
  String? selectedCharacter;
  MediumType? selectedMedium = MediumType.pencil;
  HealthBar? healthBar;

  dynamic characterDisplay;
  dynamic enemyDisplay;
  @override
  Future<void> onLoad() async {
    router = RouterComponent(
      routes: {
        'start': Route(StartScreen.new),
        'settings': Route(SettingsScreen.new),
        'game': Route(GameScreen.new),
        'pause': Route(PauseOverlay.new, transparent: true),
      },
      initialRoute: 'start',
    );
    add(router);
  }
}
