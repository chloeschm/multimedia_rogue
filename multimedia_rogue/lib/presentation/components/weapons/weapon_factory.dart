import 'package:multimedia_rogue/data/weapon_stats.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/domain/entities/weapon_stats.dart';
import 'package:multimedia_rogue/presentation/components/character/character_display.dart';
import 'package:multimedia_rogue/presentation/components/weapons/marker_weapon.dart';
import 'package:multimedia_rogue/presentation/components/weapons/melee_weapon.dart';
import 'package:multimedia_rogue/presentation/components/weapons/pen_weapon.dart';
import 'package:multimedia_rogue/presentation/components/weapons/weapon_sprite.dart';

WeaponSprite createWeapon(AnimatedCharacter host, MediumType medium) {
  final stats = weaponStats[medium] ??
      const WeaponStats(
        style: AttackStyle.melee,
        swingRaise: 1.2,
        swingSweep: 1.5,
      );
  switch (stats.style) {
    case AttackStyle.ranged:
      return PenWeapon(host: host, stats: stats);
    case AttackStyle.trail:
      return MarkerWeapon(host: host, stats: stats);
    case AttackStyle.melee:
      return MeleeWeapon(host: host, stats: stats);
  }
}
