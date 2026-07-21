import 'package:multimedia_rogue/domain/entities/medium.dart';

enum AnimationState { idle, run, attack, runAttack }

class CharacterAnimationRow {
  final int rowIndex;
  final int frameCount;
  final double stepTime;
  final double yOffset;
  final double? frameHeightOverride;

  const CharacterAnimationRow({
    required this.rowIndex,
    required this.frameCount,
    required this.stepTime,
    this.yOffset = 0.0,
    this.frameHeightOverride,
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
    spriteSheet: 'pencilgirlsheet.png',
    frameWidth:  2996 / 6,
    frameHeight: 2159 / 4,
    animations: {
      AnimationState.attack:    CharacterAnimationRow(rowIndex: 0, frameCount: 6, stepTime: 0.10),
      AnimationState.runAttack: CharacterAnimationRow(rowIndex: 1, frameCount: 6, stepTime: 0.10),
      AnimationState.idle:      CharacterAnimationRow(rowIndex: 2, frameCount: 4, stepTime: 0.20),
      AnimationState.run:       CharacterAnimationRow(rowIndex: 3, frameCount: 6, stepTime: 0.12),
    },
  );

  static const _pencilBoy = CharacterAnimationConfig(
    spriteSheet: 'pencilboysheet.png',
    frameWidth:  2852 / 6,
    frameHeight: 2160 / 4,
    animations: {
      AnimationState.attack:    CharacterAnimationRow(rowIndex: 0, frameCount: 6, stepTime: 0.10),
      AnimationState.runAttack: CharacterAnimationRow(rowIndex: 1, frameCount: 6, stepTime: 0.10),
      AnimationState.idle:      CharacterAnimationRow(rowIndex: 2, frameCount: 4, stepTime: 0.20, yOffset: 20),
      AnimationState.run:       CharacterAnimationRow(rowIndex: 3, frameCount: 6, stepTime: 0.12, yOffset: 40, frameHeightOverride: 500),
    },
  );

  static const _pencilAndro = CharacterAnimationConfig(
    spriteSheet: 'pencilandrosheet.png',
    frameWidth:  2985 / 6,
    frameHeight: 2160 / 4,
    animations: {
      AnimationState.attack:    CharacterAnimationRow(rowIndex: 0, frameCount: 6, stepTime: 0.10),
      AnimationState.runAttack: CharacterAnimationRow(rowIndex: 1, frameCount: 6, stepTime: 0.10),
      AnimationState.idle:      CharacterAnimationRow(rowIndex: 2, frameCount: 4, stepTime: 0.20, yOffset: 20),
      AnimationState.run:       CharacterAnimationRow(rowIndex: 3, frameCount: 6, stepTime: 0.12, yOffset: 40, frameHeightOverride: 500),
    },
  );

  static const _penGirl = CharacterAnimationConfig(
    spriteSheet: 'pengirlsheet.png',
    frameWidth:  2912 / 6,
    frameHeight: 2160 / 4,
    animations: {
      AnimationState.attack:    CharacterAnimationRow(rowIndex: 0, frameCount: 6, stepTime: 0.10),
      AnimationState.runAttack: CharacterAnimationRow(rowIndex: 1, frameCount: 6, stepTime: 0.10),
      AnimationState.idle:      CharacterAnimationRow(rowIndex: 2, frameCount: 4, stepTime: 0.20),
      AnimationState.run:       CharacterAnimationRow(rowIndex: 3, frameCount: 6, stepTime: 0.12),
    },
  );

  static const _penBoy = CharacterAnimationConfig(
    spriteSheet: 'penboysheet.png',
    frameWidth:  3192 / 6,
    frameHeight: 2160 / 4,
    animations: {
      AnimationState.attack:    CharacterAnimationRow(rowIndex: 0, frameCount: 6, stepTime: 0.10),
      AnimationState.runAttack: CharacterAnimationRow(rowIndex: 1, frameCount: 6, stepTime: 0.10),
      AnimationState.idle:      CharacterAnimationRow(rowIndex: 2, frameCount: 4, stepTime: 0.20, yOffset: 20),
      AnimationState.run:       CharacterAnimationRow(rowIndex: 3, frameCount: 6, stepTime: 0.12, yOffset: 40, frameHeightOverride: 500),
    },
  );

  static const _penAndro = CharacterAnimationConfig(
    spriteSheet: 'penandrosheet.png',
    frameWidth:  2841 / 6,
    frameHeight: 2160 / 4,
    animations: {
      AnimationState.attack:    CharacterAnimationRow(rowIndex: 0, frameCount: 6, stepTime: 0.10),
      AnimationState.runAttack: CharacterAnimationRow(rowIndex: 1, frameCount: 6, stepTime: 0.10),
      AnimationState.idle:      CharacterAnimationRow(rowIndex: 2, frameCount: 4, stepTime: 0.20, yOffset: 20),
      AnimationState.run:       CharacterAnimationRow(rowIndex: 3, frameCount: 6, stepTime: 0.12, yOffset: 40, frameHeightOverride: 500),
    },
  );

  static const Map<String, Map<MediumType, CharacterAnimationConfig>> byCharacterAndMedium = {
    'girl_character.png': {
      MediumType.pencil: _pencilGirl,
      MediumType.pen: _penGirl,
    },
    'boy_character.png': {
      MediumType.pencil: _pencilBoy,
      MediumType.pen: _penBoy,
    },
    'andro_character.png': {
      MediumType.pencil: _pencilAndro,
      MediumType.pen: _penAndro,
    },
  };
}
