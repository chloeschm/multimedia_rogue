import 'dart:math' show min;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

import 'package:multimedia_rogue/presentation/components/character/character_select.dart';
import 'package:multimedia_rogue/presentation/components/draft_counter.dart';
import 'package:multimedia_rogue/presentation/components/buttons/quit_button.dart';
import 'package:multimedia_rogue/presentation/components/buttons/settings_button.dart';
import 'package:multimedia_rogue/presentation/components/buttons/start_button.dart';
import 'package:multimedia_rogue/presentation/components/title.dart';
import 'package:multimedia_rogue/presentation/mixins/page_screen.dart';

class StartScreen extends PageScreen with TapCallbacks {
  static bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = game.size;

    final title = Title();
    title.size = Vector2(paperSize.x * 0.65, paperSize.y * 0.19);
    title.position = Vector2(
      paperPosition.x + (paperSize.x - title.size.x) / 2,
      paperPosition.y + paperSize.y * 0.045,
    );
    add(title);

    // On mobile in landscape, paperSize.x is the long dimension (~680px), so
    // using it as the button base makes the button ~145px tall and crushes the
    // layout. Use the shorter paper dimension instead so the button stays
    // proportionate in both orientations. Web uses paperSize.x unchanged.
    final buttonBase = _isMobile ? min(paperSize.x, paperSize.y) : paperSize.x;
    final startButton = StartButton();
    startButton.size = Vector2(buttonBase * 0.31, buttonBase * 0.31 * 0.686);
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

    // portraitMode only applies when the screen is actually taller than wide
    // (true portrait). In landscape mobile game.size.y < game.size.x so
    // portraitMode is false and the original game.size.y * 0.25 formula is
    // used — which is correct and proportionate in landscape.
    // Web is always landscape-ish so portraitMode is always false there.
    final isPortrait = !kIsWeb && game.size.y > game.size.x * 1.2;
    final characterSelect = CharacterSelect(portraitMode: isPortrait);
    characterSelect.position = Vector2(
      paperPosition.x + paperSize.x * 0.17,
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
