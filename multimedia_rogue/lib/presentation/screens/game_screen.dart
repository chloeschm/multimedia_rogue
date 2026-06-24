import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/settings_button.dart';
import 'package:multimedia_rogue/presentation/components/weapon_slots.dart';
import 'package:multimedia_rogue/presentation/mixins/drop_shadow.dart';
import 'package:multimedia_rogue/presentation/world_overlays/pencil_world.dart';

class GameScreen extends PositionComponent
    with TapCallbacks, HasGameReference<MyGame>, HasDropShadow {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = game.size;
    await add(PencilWorld());

    final healthBar = SpriteComponent()
      ..sprite = await Sprite.load('health10.png');
    healthBar.size = Vector2(game.size.x * 0.2, game.size.y * 0.07);
    healthBar.position = Vector2(game.size.x * 0.01, game.size.y * 0.03);
    add(healthBar);

    final settingsButton = SettingsButton();
    settingsButton.size = Vector2(game.size.x * 0.1, game.size.y * 0.05);
    settingsButton.position = Vector2(
      game.size.x - settingsButton.size.x - game.size.x * 0.01,
      game.size.y * 0.03,
    );
    add(settingsButton);

    final healthBarRight = game.size.x * 0.21;
    final settingsLeft = game.size.x * 0.89;
    final slotsWidth = game.size.x * 0.59;
    final slotsX = healthBarRight + (settingsLeft - healthBarRight - slotsWidth) / 2;

    final weaponSlots = WeaponSlots();
    weaponSlots.position = Vector2(slotsX, game.size.y * 0.02);
    add(weaponSlots);
  }
}
