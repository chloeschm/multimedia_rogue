import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/domain/entities/player_health.dart';
import 'package:multimedia_rogue/presentation/components/exit_door.dart';
import 'package:multimedia_rogue/presentation/components/health_bar.dart';
import 'package:multimedia_rogue/presentation/components/weapons/weapon_slots.dart';
import 'package:multimedia_rogue/presentation/input/movement_controller.dart';
import 'package:multimedia_rogue/presentation/screens/game_screen.dart';
import 'package:multimedia_rogue/presentation/screens/game_over_screen.dart';
import 'package:multimedia_rogue/presentation/screens/victory_screen.dart';
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
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late final RouterComponent router;
  final PlayerHealth player = PlayerHealth();
  final Set<MediumType> unlockedMediums = {MediumType.pencil};
  int draftCount = 0;
  final MovementController movementController = MovementController();
  String? selectedCharacter;
  HealthBar? healthBar;
  ExitDoor? exitDoor;
  MediumType? selectedMedium;
  WeaponSlots? weaponSlots;

  dynamic characterDisplay;
  dynamic enemyDisplay;
  @override
  Future<void> onLoad() async {
    router = RouterComponent(
      routes: {
        'start': Route(StartScreen.new),
        'settings': Route(SettingsScreen.new),
        'game': Route(GameScreen.new, maintainState: false),
        'pause': Route(PauseOverlay.new, transparent: true),
        'gameover': Route(GameOverScreen.new, maintainState: false),
        'victory': Route(VictoryScreen.new, maintainState: false),
      },
      initialRoute: 'start',
    );
    add(router);
  }
}
