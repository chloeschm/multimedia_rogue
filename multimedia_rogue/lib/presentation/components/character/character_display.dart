import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:multimedia_rogue/data/medium_weapon_assets.dart';
import 'package:multimedia_rogue/domain/entities/animation_state.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/character/character_animations.dart';
import 'package:multimedia_rogue/presentation/components/combat/player_contact_hitbox.dart';
import 'package:multimedia_rogue/presentation/components/enemy/enemy_display.dart';
import 'package:multimedia_rogue/presentation/components/weapons/weapon_factory.dart';
import 'package:multimedia_rogue/presentation/mixins/drop_shadow.dart';

class CharacterDisplay extends PositionComponent with HasGameReference<MyGame> {
  PositionComponent? _sprite;
  int _generation = 0;
  double speed = 200.0;
  bool _placed = false;
  int _puddleContacts = 0;
  double _hitFlash = 0.0;

  void enterPuddle() => _puddleContacts++;

  void exitPuddle() {
    if (_puddleContacts > 0) _puddleContacts--;
  }

  void flashHit() => _hitFlash = 0.8;

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

    if (_sprite is AnimatedCharacter) {
      final animated = _sprite as AnimatedCharacter;
      animated.setState(
        dir.length > 0 ? AnimationState.run : AnimationState.idle,
      );
      animated.setFacing(dir.x);
    }

    if (dir.length > 0) {
      final drawing =
          game.movementController.isAttacking &&
          game.selectedMedium == MediumType.marker;
      final slow =
          (_puddleContacts > 0 ? 0.45 : 1.0) * (drawing ? 0.7 : 1.0);
      position += dir * game.movementController.speed * slow * dt;
    }

    if (_hitFlash > 0) {
      _hitFlash -= dt;
      final flashOpacity =
          _hitFlash <= 0 || sin(_hitFlash * 25) <= 0 ? 1.0 : 0.35;
      final visual = _sprite;
      if (visual is SpriteAnimationComponent) {
        visual.opacity = flashOpacity;
      } else if (visual is SpriteComponent) {
        visual.opacity = flashOpacity;
      }
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

  void refreshMedium() {
    _refresh();
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
          AnimatedCharacter(
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

    if (!_placed) {
      position = pos;
      _placed = true;
    }

    if (generation != _generation) return;
    _sprite = newSprite;
    add(_sprite!);

    showScribble();
  }
}

class AnimatedCharacter extends SpriteAnimationComponent
    with HasDropShadow, HasGameReference<MyGame> {
  final Map<AnimationState, SpriteAnimation> _animations;
  final Map<AnimationState, double> _stepTimes;
  final MediumType? medium;

  AnimationState _currentState = AnimationState.idle;
  int _currentFrameIndex = 0;
  double _elapsed = 0;

  AnimationState get currentState => _currentState;
  int get currentFrameIndex => _currentFrameIndex;

  AnimatedCharacter({
    required Map<AnimationState, SpriteAnimation> animations,
    required Map<AnimationState, double> stepTimes,
    this.medium,
  }) : _animations = animations,
       _stepTimes = stepTimes,
       super(animation: animations[AnimationState.idle], anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final currentMedium = medium;
    final asset =
        currentMedium != null ? mediumWeaponAssets[currentMedium] : null;
    if (asset != null && currentMedium != null) {
      final img = await game.images.load(asset.spritePath);
      final weaponSize = Vector2(size.x * 0.32, size.x * 0.32);
      final weapon = createWeapon(this, currentMedium)
        ..sprite = Sprite(img)
        ..size = weaponSize
        ..anchor = Anchor.center
        ..angle = asset.angle;
      add(weapon);
    }
  }

  void spawnInWorld(Component component) {
    (game.characterDisplay as PositionComponent?)?.parent?.add(component);
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
