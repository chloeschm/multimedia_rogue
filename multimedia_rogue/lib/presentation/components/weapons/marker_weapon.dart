import 'package:flame/components.dart';
import 'package:multimedia_rogue/presentation/components/combat/marker_trail.dart';
import 'package:multimedia_rogue/presentation/components/weapons/weapon_sprite.dart';

class MarkerWeapon extends WeaponSprite {
  MarkerWeapon({required super.host, required super.stats});

  late double _ink = stats.maxInk;
  Vector2? _lastSegmentPos;

  @override
  void onAttack(double dt, bool attacking, bool rising) {
    if (attacking) {
      if (_ink >= stats.inkCost) {
        final pos = host.absolutePosition + Vector2(0, host.size.y * 0.35);
        if (_lastSegmentPos == null ||
            pos.distanceTo(_lastSegmentPos!) >= stats.segmentSpacing) {
          _lastSegmentPos = pos.clone();
          _ink -= stats.inkCost;
          host.spawnInWorld(MarkerTrailSegment(position: pos));
        }
      } else {
        _lastSegmentPos = null;
      }
    } else {
      _lastSegmentPos = null;
      _ink = (_ink + stats.inkRegen * dt).clamp(0.0, stats.maxInk);
    }
    opacity = 0.4 + 0.6 * (_ink / stats.maxInk);
  }
}
