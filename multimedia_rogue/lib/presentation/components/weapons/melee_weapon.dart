import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:multimedia_rogue/presentation/components/combat/swing_hitbox.dart';
import 'package:multimedia_rogue/presentation/components/weapons/weapon_sprite.dart';

class MeleeWeapon extends SwingWeapon {
  MeleeWeapon({required super.host, required super.stats});

  SwingHitbox? _swingBox;

  @override
  void onSwingStart() {
    FlameAudio.play('swoosh.wav');
    _swingBox = SwingHitbox(
      damage: stats.damage,
      offset: Vector2(size.x * 0.9, size.y * 0.1),
      radius: 3.0,
      weaponSize: size,
    );
    add(_swingBox!);
  }

  @override
  void onSwingComplete() {
    _swingBox?.removeFromParent();
  }
}
