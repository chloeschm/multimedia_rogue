import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:multimedia_rogue/presentation/components/combat/ink_shot.dart';
import 'package:multimedia_rogue/presentation/components/weapons/weapon_sprite.dart';

class PenWeapon extends SwingWeapon {
  PenWeapon({required super.host, required super.stats});

  @override
  void onSwingStart() {
    _shootInk();
    FlameAudio.play('plip.wav');
  }

  void _shootInk() {
    final facing = host.scale.x >= 0 ? 1.0 : -1.0;
    final shot = InkShot(
      direction: Vector2(facing, 0),
      position: absolutePosition,
    );
    host.spawnInWorld(shot);
  }
}
