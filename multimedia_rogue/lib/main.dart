import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:multimedia_rogue/presentation/screens/game_screen.dart';
import 'package:multimedia_rogue/presentation/screens/pause_overlay.dart';
import 'package:multimedia_rogue/presentation/screens/start_screen.dart';
import 'package:multimedia_rogue/presentation/screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final game = MyGame();
  runApp(GameWidget(game: game));
}

class MyGame extends FlameGame
    with HasCollisionDetection, HasGameReference<MyGame> {
  late final RouterComponent router;
  String? selectedCharacter;
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
