import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:multimedia_rogue/data/weapon_attachment_points.dart';
import 'package:multimedia_rogue/domain/entities/weapon_stats.dart';
import 'package:multimedia_rogue/presentation/components/character/character_display.dart';

abstract class WeaponSprite extends SpriteComponent {
  final AnimatedCharacter host;
  final WeaponStats stats;

  WeaponSprite({required this.host, required this.stats});

  static const double _offsetX = 0.08;
  static const double _offsetY = -0.10;

  bool _wasAttacking = false;

  @override
  void update(double dt) {
    super.update(dt);

    final attacking = host.game.movementController.isAttacking;
    final rising = attacking && !_wasAttacking;
    onAttack(dt, attacking, rising);
    _wasAttacking = attacking;

    _followAttachment();
  }

  void onAttack(double dt, bool attacking, bool rising);

  void _followAttachment() {
    final medium = host.medium;
    if (medium == null) return;
    final offset = getAttachmentPoint(
      medium,
      host.currentState,
      host.currentFrameIndex,
    );
    if (offset == null) return;
    position = Vector2(
      (offset.x + _offsetX) * host.size.x,
      (offset.y + _offsetY) * host.size.y,
    );
  }
}

abstract class SwingWeapon extends WeaponSprite {
  SwingWeapon({required super.host, required super.stats});

  bool _swinging = false;

  void onSwingStart();

  void onSwingComplete() {}

  @override
  void onAttack(double dt, bool attacking, bool rising) {
    if (rising && !_swinging) _startSwing();
  }

  void _startSwing() {
    _swinging = true;
    final rest = angle;
    onSwingStart();
    add(
      SequenceEffect(
        [
          RotateEffect.to(
            rest - stats.swingRaise,
            EffectController(duration: 0.06, curve: Curves.easeOut),
          ),
          RotateEffect.to(
            rest + stats.swingSweep,
            EffectController(duration: 0.12, curve: Curves.easeIn),
          ),
          RotateEffect.to(
            rest,
            EffectController(duration: 0.18, curve: Curves.easeOut),
          ),
        ],
        onComplete: () {
          onSwingComplete();
          _swinging = false;
        },
      ),
    );
  }
}
