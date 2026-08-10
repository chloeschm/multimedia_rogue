import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:multimedia_rogue/data/medium_weapon_assets.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/character/character_display.dart';

class WeaponPickup extends SpriteComponent
    with HasGameReference<MyGame>, CollisionCallbacks {
  static const double _pickupDelay = 2.5;

  final MediumType mediumType;

  double _age = 0.0;
  bool _armed = false;

  WeaponPickup({required Vector2 position, required this.mediumType})
    : super(position: position, anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final asset = mediumWeaponAssets[mediumType];
    if (asset != null) {
      sprite = await Sprite.load(asset.spritePath);
    }
    size = Vector2.all(game.size.x * 0.045);
    opacity = 0.45;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_armed) return;
    _age += dt;
    if (_age >= _pickupDelay) {
      _armed = true;
      opacity = 1.0;
      add(
        CircleHitbox.relative(
          1.8,
          parentSize: size,
          position: size / 2,
          anchor: Anchor.center,
        )..collisionType = CollisionType.passive,
      );
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is CharacterDisplay) {
      FlameAudio.play('plip.wav');
      game.weaponSlots?.unlockMedium(mediumType);
      game.weaponSlots?.selectMedium(mediumType);
      game.exitDoor?.open();
      removeFromParent();
    }
  }
}
