import 'package:multimedia_rogue/domain/entities/medium.dart';

enum AnimationState { idle, run, attack, runAttack }

class CharacterAnimationRow {
  final int rowIndex;
  final int frameCount;
  final double stepTime;

  const CharacterAnimationRow({
    required this.rowIndex,
    required this.frameCount,
    required this.stepTime,
  });
}

class CharacterAnimationConfig {
  final String spriteSheet;
  final double frameWidth;
  final double frameHeight;
  final Map<AnimationState, CharacterAnimationRow> animations;

  const CharacterAnimationConfig({
    required this.spriteSheet,
    required this.frameWidth,
    required this.frameHeight,
    required this.animations,
  });
}

class CharacterAnimations {
  static const _pencilGirl = CharacterAnimationConfig(
    spriteSheet: 'pencilgirlsheet.jpg',
    frameWidth: 2996 / 6,   
    frameHeight: 2159 / 4, 
    animations: {
      AnimationState.attack:    CharacterAnimationRow(rowIndex: 0, frameCount: 6, stepTime: 0.10),
      AnimationState.runAttack: CharacterAnimationRow(rowIndex: 1, frameCount: 6, stepTime: 0.10),
      AnimationState.idle:      CharacterAnimationRow(rowIndex: 2, frameCount: 4, stepTime: 0.20),
      AnimationState.run:       CharacterAnimationRow(rowIndex: 3, frameCount: 6, stepTime: 0.12),
    },
  );

  static const Map<String, Map<MediumType, CharacterAnimationConfig>> byCharacterAndMedium = {
    'girl_character.png': {
      MediumType.pencil: _pencilGirl,
    },
  };
}
