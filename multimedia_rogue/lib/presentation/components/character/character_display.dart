import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/animation.dart';
import 'package:multimedia_rogue/data/medium_weapon_assets.dart';
import 'package:multimedia_rogue/data/weapon_attachment_points.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/combat/player_contact_hitbox.dart';
import 'package:multimedia_rogue/presentation/components/combat/swing_hitbox.dart';
import 'package:multimedia_rogue/presentation/components/enemy/enemy_display.dart';
import 'character_animations.dart';
import '../../mixins/drop_shadow.dart';

class CharacterDisplay extends PositionComponent with HasGameReference<MyGame> {
  PositionComponent? _sprite;
  int _generation = 0;
  double speed = 200.0;

  @override
  void onMount() {
    super.onMount();
    game.characterDisplay = this;
    size = Vector2(game.size.x * 0.10, game.size.y * 0.20);
    add(PlayerContactHitbox());
    _refresh();
  }

  @override
  void onRemove() {
    if (game.characterDisplay == this) game.characterDisplay = null;
    super.onRemove();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_sprite == null) return;
    final dir = game.movementController.direction;

    if (_sprite is _AnimatedCharacter) {
      final animated = _sprite as _AnimatedCharacter;
      animated.setState(
        dir.length > 0 ? AnimationState.run : AnimationState.idle,
      );
      animated.setFacing(dir.x);
    }

    if (dir.length > 0) {
      position += dir * game.movementController.speed * dt;
    }

    for (var enemy in game.children.whereType<Enemy>()) {
      final distance = position.distanceTo(enemy.position);
      if (distance < 75) {
        final offset = position - enemy.position;

        if (offset.length2 > 0.01) {
          final pushBack = offset.normalized();
          position += pushBack * speed * 0.8 * dt;
        }
      }
    }
  }

  void showScribble() async {
    final sprite = await Sprite.load('scribble.png');
    final charSize =
        _sprite?.size ?? Vector2(game.size.x * 0.10, game.size.y * 0.20);
    final charPos =
        _sprite?.position ?? Vector2(game.size.x * 0.05, game.size.y * 0.55);
    final effect = _ScribbleEffect(sprite: sprite, charSize: charSize)
      ..position = charPos;
    add(effect);
    FlameAudio.play('scribble.wav');
  }

  void _refresh() async {
    _sprite?.removeFromParent();
    _sprite = null;
    final generation = ++_generation;

    final file = game.selectedCharacter;
    if (file == null) return;

    final w = game.size.x * 0.10;
    final h = game.size.y * 0.20;
    final pos = Vector2(game.size.x * 0.05, game.size.y * 0.55);

    final medium = game.selectedMedium;
    final config = medium == null
        ? null
        : CharacterAnimations.byCharacterAndMedium[file]?[medium];

    PositionComponent newSprite;

    if (config != null) {
      final image = await game.images.load(config.spriteSheet);

      SpriteAnimation makeAnim(CharacterAnimationRow row) {
        final fh = row.frameHeightOverride ?? config.frameHeight;
        final y0 = row.rowIndex * config.frameHeight + row.yOffset;
        final frames = List.generate(row.frameCount, (col) {
          return SpriteAnimationFrame(
            Sprite(
              image,
              srcPosition: Vector2(col * config.frameWidth, y0),
              srcSize: Vector2(config.frameWidth, fh),
            ),
            row.stepTime,
          );
        });
        return SpriteAnimation(frames, loop: true);
      }

      final animations = <AnimationState, SpriteAnimation>{};
      final stepTimes = <AnimationState, double>{};
      for (final entry in config.animations.entries) {
        animations[entry.key] = makeAnim(entry.value);
        stepTimes[entry.key] = entry.value.stepTime;
      }

      newSprite =
          _AnimatedCharacter(
              animations: animations,
              stepTimes: stepTimes,
              medium: medium,
            )
            ..size = Vector2(w, h)
            ..position = Vector2(w / 2, h / 2);
    } else {
      newSprite = _StaticCharacter()
        ..sprite = await Sprite.load(file)
        ..size = Vector2(w, h)
        ..position = Vector2.zero();
    }

    position = pos;

    if (generation != _generation) return;
    _sprite = newSprite;
    add(_sprite!);

    showScribble();
  }
}

class _AnimatedCharacter extends SpriteAnimationComponent
    with HasDropShadow, HasGameReference<MyGame> {
  final Map<AnimationState, SpriteAnimation> _animations;
  final Map<AnimationState, double> _stepTimes;
  final MediumType? medium;

  AnimationState _currentState = AnimationState.idle;
  int _currentFrameIndex = 0;
  double _elapsed = 0;

  AnimationState get currentState => _currentState;
  int get currentFrameIndex => _currentFrameIndex;

  _AnimatedCharacter({
    required Map<AnimationState, SpriteAnimation> animations,
    required Map<AnimationState, double> stepTimes,
    this.medium,
  }) : _animations = animations,
       _stepTimes = stepTimes,
       super(animation: animations[AnimationState.idle], anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final asset = medium != null ? mediumWeaponAssets[medium!] : null;
    if (asset != null) {
      final img = await game.images.load(asset.spritePath);
      final weaponSize = Vector2(size.x * 0.32, size.x * 0.32);
      final weapon = _WeaponSprite(host: this)
        ..sprite = Sprite(img)
        ..size = weaponSize
        ..anchor = Anchor.center
        ..angle = asset.angle;
      add(weapon);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final anim = _animations[_currentState];
    if (anim != null && anim.frames.isNotEmpty) {
      final stepTime = _stepTimes[_currentState] ?? 0.12;
      _elapsed += dt;
      final frameCount = anim.frames.length;
      final total = stepTime * frameCount;
      if (total > 0) {
        final looped = _elapsed % total;
        _currentFrameIndex = (looped / stepTime).floor().clamp(
          0,
          frameCount - 1,
        );
      }
    }
  }

  void setState(AnimationState state) {
    if (_currentState == state) return;
    final next = _animations[state] ?? _animations[AnimationState.idle];
    if (next == null) return;
    _currentState = state;
    _currentFrameIndex = 0;
    _elapsed = 0;
    animation = next;
  }

  void setFacing(double dirX) {
    if (dirX < 0) {
      scale.x = -1;
    } else if (dirX > 0) {
      scale.x = 1;
    }
  }
}

class _WeaponSprite extends SpriteComponent {
  final _AnimatedCharacter host;
  _WeaponSprite({required this.host});

  static const double _raise = 1.2;
  static const double _sweep = 1.5;
  static const double _offsetX = 0.08;
  static const double _offsetY = -0.10;

  bool _wasAttacking = false;
  bool _swinging = false;

  @override
  void update(double dt) {
    super.update(dt);

    final attacking = host.game.movementController.isAttacking;
    if (attacking && !_wasAttacking && !_swinging) {
      _startSwing();
    }
    _wasAttacking = attacking;

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

  void _startSwing() {
    _swinging = true;
    final rest = angle;
    final swingBox = SwingHitbox(
      damage: 1,
      offset: Vector2(size.x * 0.8, size.y * 0.1),
      radius: 0.9,
      weaponSize: size,
    );
    add(swingBox);
    add(
      SequenceEffect(
        [
          RotateEffect.to(
            rest - _raise,
            EffectController(duration: 0.06, curve: Curves.easeOut),
          ),
          RotateEffect.to(
            rest + _sweep,
            EffectController(duration: 0.12, curve: Curves.easeIn),
          ),
          RotateEffect.to(
            rest,
            EffectController(duration: 0.18, curve: Curves.easeOut),
          ),
        ],
        onComplete: () {
          swingBox.removeFromParent();
          _swinging = false;
        },
      ),
    );
  }
}

class _ScribbleEffect extends SpriteComponent {
  _ScribbleEffect({required Sprite sprite, required Vector2 charSize})
    : super(
        sprite: sprite,
        size: Vector2(charSize.x * 2.2, charSize.y * 1.4),
        anchor: Anchor.center,
      );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      OpacityEffect.fadeOut(
        SequenceEffectController([
          PauseEffectController(0.15, progress: 0.0),
          LinearEffectController(0.40),
        ]),
      ),
    );
    add(RemoveEffect(delay: 0.55));
  }
}

class _StaticCharacter extends SpriteComponent with HasDropShadow {}
