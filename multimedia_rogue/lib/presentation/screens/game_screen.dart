import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/character/character_display.dart';
import 'package:multimedia_rogue/presentation/components/buttons/pause_button.dart';
import 'package:multimedia_rogue/presentation/components/buttons/settings_button.dart';
import 'package:multimedia_rogue/presentation/components/weapon_slots.dart';
import 'package:multimedia_rogue/presentation/input/joystick_adapter.dart';
import 'package:multimedia_rogue/presentation/input/keyboard_adapter.dart';
import 'package:multimedia_rogue/presentation/mixins/drop_shadow.dart';
import 'package:multimedia_rogue/presentation/world_overlays/pencil_world.dart';

class GameScreen extends PositionComponent
    with TapCallbacks, HasGameReference<MyGame>, HasDropShadow {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = game.size;
    await add(PencilWorld());
    add(CharacterDisplay());

    // Input adapters — keyboard always active (web + desktop).
    // Joystick stub added on mobile; wire it up when implementing touch controls.
    add(KeyboardAdapter());
    final isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    if (isMobile) add(JoystickAdapter());

    final healthBar = SpriteComponent()
      ..sprite = await Sprite.load('health10.png');
    healthBar.size = Vector2(game.size.x * 0.2, game.size.y * 0.07);
    healthBar.position = Vector2(game.size.x * 0.01, game.size.y * 0.03);
    add(healthBar);

    final buttonWidth = game.size.x * 0.1;
    final buttonHeight = game.size.y * 0.05;
    final buttonX = game.size.x - buttonWidth - game.size.x * 0.01;
    final buttonGap = game.size.y * 0.01;

    final settingsButton = SettingsButton();
    settingsButton.size = Vector2(buttonWidth, buttonHeight);
    settingsButton.position = Vector2(buttonX, game.size.y * 0.01);
    add(settingsButton);

    final pauseButton = PauseButton();
    pauseButton.size = Vector2(buttonWidth, buttonHeight);
    pauseButton.position = Vector2(
      buttonX,
      settingsButton.position.y + buttonHeight + buttonGap,
    );
    add(pauseButton);

    final healthBarRight = game.size.x * 0.21;
    final settingsLeft = game.size.x * 0.89;
    final slotsWidth = game.size.x * 0.59;
    final slotsX = healthBarRight + (settingsLeft - healthBarRight - slotsWidth) / 2;

    final weaponSlots = WeaponSlots();
    weaponSlots.position = Vector2(slotsX, game.size.y * 0.02);
    add(weaponSlots);
  }
}
