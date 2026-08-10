import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/domain/entities/weapon_stats.dart';

const double _baseRaise = 1.2;
const double _baseSweep = 1.5;

const Map<MediumType, WeaponStats> weaponStats = {
  MediumType.pencil: WeaponStats(
    style: AttackStyle.melee,
    swingRaise: _baseRaise,
    swingSweep: _baseSweep,
  ),
  MediumType.watercolor: WeaponStats(
    style: AttackStyle.melee,
    swingRaise: _baseRaise,
    swingSweep: _baseSweep,
  ),
  MediumType.pen: WeaponStats(
    style: AttackStyle.ranged,
    swingRaise: _baseRaise * 0.4,
    swingSweep: _baseSweep * 0.3,
  ),
  MediumType.marker: WeaponStats(
    style: AttackStyle.trail,
    maxInk: 100.0,
    inkCost: 4.0,
    inkRegen: 18.0,
    segmentSpacing: 20.0,
  ),
};
