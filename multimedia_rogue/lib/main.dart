import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:multimedia_rogue/presentation/screens/start_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final game = MyGame();
  runApp(GameWidget(game: game));
}

class MyGame extends FlameGame
    with HasCollisionDetection, HasGameReference<MyGame> {
  late final RouterComponent router;
  @override
  Future<void> onLoad() async {
    router = RouterComponent(
      routes: {'start': Route(StartScreen.new)},
      initialRoute: 'start',
    );
    add(router);
  }
}
