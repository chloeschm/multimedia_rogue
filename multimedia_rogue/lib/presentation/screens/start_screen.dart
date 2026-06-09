import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:multimedia_rogue/presentation/components/character_select.dart';
import 'package:multimedia_rogue/presentation/components/draft_counter.dart';
import 'package:multimedia_rogue/presentation/components/settings_button.dart';
import 'package:multimedia_rogue/presentation/components/quit_button.dart';
import 'package:multimedia_rogue/presentation/components/start_button.dart';

class StartScreen extends PositionComponent with TapCallbacks {
  @override
  Future<void> onLoad() async {
    final bg = SpriteComponent()
      ..sprite = await Sprite.load('desk_background.png')
      ..size = size;
    add(bg);

    // title placeholder
    add(TextComponent(text: 'Pagebound', position: Vector2(100, 50)));

    add(StartButton());

    // settings button placeholder
    add(SettingsButton());

    // quit button placeholder
    add(QuitButton());

    // character select placeholder
    add(CharacterSelect());

    // draft counter placeholder
    add(DraftCounter());

  }
}
