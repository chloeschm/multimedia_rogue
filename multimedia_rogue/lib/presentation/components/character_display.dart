import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:multimedia_rogue/main.dart';
import 'character_animations.dart';
import '../mixins/drop_shadow.dart';

class CharacterDisplay extends PositionComponent with HasGameReference<MyGame> {
  PositionComponent? _sprite;
  int _generation = 0;

  @override
  void onMount() {
    super.onMount();
    _refresh();
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
      _sprite!.position += dir * game.movementController.speed * dt;
    }
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
      final sheet = SpriteSheet(
        image: image,
        srcSize: Vector2(config.frameWidth, config.frameHeight),
      );

      SpriteAnimation _makeAnim(CharacterAnimationRow row) =>
          sheet.createAnimation(
            row: row.rowIndex,
            stepTime: row.stepTime,
            from: 0,
            to: row.frameCount,
            loop: true,
          );

      final animations = <AnimationState, SpriteAnimation>{};
      for (final entry in config.animations.entries) {
        animations[entry.key] = _makeAnim(entry.value);
      }

      newSprite = _AnimatedCharacter(animations: animations)
        ..size = Vector2(w, h)
        ..position = pos;
    } else {
      newSprite = _StaticCharacter()
        ..sprite = await Sprite.load(file)
        ..size = Vector2(w, h)
        ..position = pos;
    }

    if (generation != _generation) return;
    _sprite = newSprite;
    add(_sprite!);
  }
}

class _AnimatedCharacter extends SpriteAnimationComponent with HasDropShadow {
  final Map<AnimationState, SpriteAnimation> _animations;
  AnimationState _currentState = AnimationState.idle;

  _AnimatedCharacter({required Map<AnimationState, SpriteAnimation> animations})
      : _animations = animations,
        super(animation: animations[AnimationState.idle], anchor: Anchor.center);

  void setState(AnimationState state) {
    if (_currentState == state) return;
    final next = _animations[state] ?? _animations[AnimationState.idle];
    if (next == null) return;
    _currentState = state;
    animation = next;
  }

  void setFacing(double dirX) {
    if (dirX < 0) scale.x = -1;
    else if (dirX > 0) scale.x = 1;
  }
}

class _StaticCharacter extends SpriteComponent with HasDropShadow {}
