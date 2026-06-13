import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/settings_button.dart';
import 'package:multimedia_rogue/presentation/components/weapon_slots.dart';
import 'package:multimedia_rogue/presentation/world_overlays/pencil_world.dart';

class GameScreen extends PositionComponent
    with TapCallbacks, HasGameReference<MyGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = game.size;
    await add(PencilWorld());

    final healthBar = SpriteComponent()
      ..sprite = await Sprite.load('health_bar.png');
    healthBar.size = Vector2(size.x * 0.2, size.y * 0.07);
    healthBar.position = Vector2(size.x * 0.03, size.y * 0.03);
    add(healthBar);

    final weaponSlots = WeaponSlots();
    weaponSlots.position = Vector2((size.x - size.x * 0.7) / 2, size.y * 0.02);
    add(weaponSlots);

    final settingsButton = SettingsButton();
    settingsButton.size = Vector2(size.x * 0.1, size.y * 0.05);
    settingsButton.position = Vector2(
      size.x - settingsButton.size.x - size.x * 0.03,
      size.y * 0.03,
    );
    add(settingsButton);
  }
}
