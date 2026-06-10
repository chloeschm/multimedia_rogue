import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:multimedia_rogue/main.dart';

import 'package:multimedia_rogue/presentation/components/character_select.dart';
import 'package:multimedia_rogue/presentation/components/draft_counter.dart';
import 'package:multimedia_rogue/presentation/components/quit_button.dart';
import 'package:multimedia_rogue/presentation/components/settings_button.dart';
import 'package:multimedia_rogue/presentation/components/start_button.dart';
import 'package:multimedia_rogue/presentation/components/title.dart';

class StartScreen extends PositionComponent
    with TapCallbacks, HasGameReference<MyGame> {
  @override
  Future<void> onLoad() async {
    size = game.size;

    final bg = SpriteComponent()
      ..sprite = await Sprite.load('background.png')
      ..size = size;
    add(bg);

    final paperSize = size * 0.8;
    final paperPosition = Vector2(
      (size.x - paperSize.x) / 2,
      (size.y - paperSize.y) / 2,
    );
    final paper = SpriteComponent()
      ..sprite = await Sprite.load('paper.png')
      ..size = paperSize
      ..position = paperPosition;
    add(paper);

    final title = Title();
    title.size = Vector2(paperSize.x * 0.65, paperSize.y * 0.19);
    title.position = Vector2(
      paperPosition.x + (paperSize.x - title.size.x) / 2,
      paperPosition.y + paperSize.y * 0.045,
    );
    add(title);

    final startButton = StartButton();
    startButton.size = Vector2(paperSize.x * 0.31, paperSize.x * 0.31 * 0.686);
    startButton.position = Vector2(
      paperPosition.x + (paperSize.x - startButton.size.x) / 2,
      paperPosition.y + paperSize.y * 0.27,
    );
    add(startButton);

    final draftCounter = DraftCounter();
    draftCounter.position = Vector2(
      paperPosition.x + paperSize.x * 0.03,
      startButton.position.y + startButton.size.y * 0.15,
    );
    draftCounter.scale = Vector2.all(1);
    add(draftCounter);

    final characterSelect = CharacterSelect();
    characterSelect.size = Vector2(paperSize.x * 0.58, paperSize.y * 0.30);
    characterSelect.position = Vector2(
      paperPosition.x +
          (paperSize.x - characterSelect.size.x) / 2 -
          paperSize.x * 0.04,
      paperPosition.y + paperSize.y * 0.54,
    );
    add(characterSelect);

    final settingsButton = SettingsButton();
    settingsButton.size = Vector2(paperSize.x * 0.18, paperSize.y * 0.07);
    settingsButton.position = Vector2(
      paperPosition.x +
          paperSize.x -
          settingsButton.size.x -
          paperSize.x * 0.03,
      paperPosition.y + paperSize.y * 0.82,
    );
    add(settingsButton);

    final quitButton = QuitButton();
    quitButton.size = settingsButton.size.clone();
    quitButton.position = Vector2(
      settingsButton.position.x,
      settingsButton.position.y + settingsButton.size.y + paperSize.y * 0.02,
    );
    add(quitButton);
  }
}
