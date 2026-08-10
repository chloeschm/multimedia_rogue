import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:multimedia_rogue/presentation/components/character/character_select.dart';
import 'package:multimedia_rogue/presentation/components/draft_counter.dart';
import 'package:multimedia_rogue/presentation/components/buttons/quit_button.dart';
import 'package:multimedia_rogue/presentation/components/buttons/settings_button.dart';
import 'package:multimedia_rogue/presentation/components/buttons/start_button.dart';
import 'package:multimedia_rogue/presentation/components/title.dart';
import 'package:multimedia_rogue/presentation/mixins/page_screen.dart';

class StartScreen extends PageScreen with TapCallbacks {
  static const double _titleAspect = 3.558;
  static const double _startAspect = 1.458;
  static const double _settingsAspect = 2.716;
  static const double _quitAspect = 2.131;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = game.size;

    final title = Title();
    title.size = Vector2(paperSize.y * 0.19 * _titleAspect, paperSize.y * 0.19);
    title.position = Vector2(
      paperPosition.x + (paperSize.x - title.size.x) / 2,
      paperPosition.y + paperSize.y * 0.04,
    );
    add(title);

    final startButton = StartButton();
    startButton.size = Vector2(
      paperSize.y * 0.42,
      paperSize.y * 0.42 / _startAspect,
    );
    startButton.position = Vector2(
      paperPosition.x + (paperSize.x - startButton.size.x) / 2,
      paperPosition.y + paperSize.y * 0.26,
    );
    add(startButton);

    final draftCounter = DraftCounter();
    draftCounter.position = Vector2(
      paperPosition.x + paperSize.x * 0.09,
      startButton.position.y + startButton.size.y * 0.15,
    );
    draftCounter.scale = Vector2.all(1);
    add(draftCounter);

    final characterSelect = CharacterSelect();
    characterSelect.anchor = Anchor.topCenter;
    characterSelect.position = Vector2(
      paperPosition.x + paperSize.x / 2,
      paperPosition.y + paperSize.y * 0.63,
    );
    add(characterSelect);

    final settingsButton = SettingsButton();
    settingsButton.size = Vector2(
      paperSize.y * 0.10 * _settingsAspect,
      paperSize.y * 0.10,
    );
    settingsButton.position = Vector2(
      paperPosition.x + paperSize.x - settingsButton.size.x - paperSize.x * 0.03,
      paperPosition.y + paperSize.y * 0.74,
    );
    add(settingsButton);

    final quitButton = QuitButton();
    quitButton.size = Vector2(
      paperSize.y * 0.10 * _quitAspect,
      paperSize.y * 0.10,
    );
    quitButton.position = Vector2(
      paperPosition.x + paperSize.x - quitButton.size.x - paperSize.x * 0.03,
      settingsButton.position.y + settingsButton.size.y + paperSize.y * 0.02,
    );
    add(quitButton);
  }
}
