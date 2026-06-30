import 'dart:math' as math;
import 'package:multimedia_rogue/domain/entities/medium.dart';

/// Per-weapon sprite + rotation so the weapon tip always points upward
/// when attached to the character's hand.
/// [angle] is in radians; positive = clockwise in Flame.
class WeaponAsset {
  final String spritePath;

  /// Rotation applied to the weapon sprite so the tip faces up.
  /// Tune this per-weapon based on the original sprite orientation.
  final double angle;

  const WeaponAsset({required this.spritePath, this.angle = 0.0});
}

const Map<MediumType, WeaponAsset> mediumWeaponAssets = {
  MediumType.pencil:     WeaponAsset(spritePath: 'pencilweapon.png',     angle: -math.pi / 2),
  MediumType.pen:        WeaponAsset(spritePath: 'penweapon.png',        angle: -math.pi / 2),
  MediumType.marker:     WeaponAsset(spritePath: 'markerweapon.png',     angle: -math.pi / 2),
  MediumType.brush:      WeaponAsset(spritePath: 'brushweapon.png',      angle: -math.pi / 2),
  MediumType.watercolor: WeaponAsset(spritePath: 'watercolorweapon.png', angle: -math.pi / 2),
  MediumType.pastel:     WeaponAsset(spritePath: 'pastelweapon.png',     angle: -math.pi / 2),
};
