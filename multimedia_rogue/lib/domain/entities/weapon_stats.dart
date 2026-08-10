enum AttackStyle { melee, ranged, trail }

class WeaponStats {
  final AttackStyle style;
  final int damage;
  final double swingRaise;
  final double swingSweep;
  final double maxInk;
  final double inkCost;
  final double inkRegen;
  final double segmentSpacing;

  const WeaponStats({
    required this.style,
    this.damage = 1,
    this.swingRaise = 0.0,
    this.swingSweep = 0.0,
    this.maxInk = 0.0,
    this.inkCost = 0.0,
    this.inkRegen = 0.0,
    this.segmentSpacing = 0.0,
  });
}
