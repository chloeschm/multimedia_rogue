import 'package:multimedia_rogue/domain/entities/animation_state.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';

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

  static const _markerGirl = CharacterAnimationConfig(
    spriteSheet: 'markergirlsheet.png',
    frameWidth:  2916 / 6,
    frameHeight: 2160 / 4,
    animations: {
      AnimationState.attack:    CharacterAnimationRow(rowIndex: 0, frameCount: 6, stepTime: 0.10),
      AnimationState.runAttack: CharacterAnimationRow(rowIndex: 1, frameCount: 6, stepTime: 0.10),
      AnimationState.idle:      CharacterAnimationRow(rowIndex: 2, frameCount: 4, stepTime: 0.20),
      AnimationState.run:       CharacterAnimationRow(rowIndex: 3, frameCount: 6, stepTime: 0.12),
    },
  );

  static const _markerBoy = CharacterAnimationConfig(
    spriteSheet: 'markerboysheet.png',
    frameWidth:  2912 / 6,
    frameHeight: 2160 / 4,
    animations: {
      AnimationState.attack:    CharacterAnimationRow(rowIndex: 0, frameCount: 6, stepTime: 0.10),
      AnimationState.runAttack: CharacterAnimationRow(rowIndex: 1, frameCount: 6, stepTime: 0.10),
      AnimationState.idle:      CharacterAnimationRow(rowIndex: 2, frameCount: 4, stepTime: 0.20, yOffset: 20),
      AnimationState.run:       CharacterAnimationRow(rowIndex: 3, frameCount: 6, stepTime: 0.12, yOffset: 40, frameHeightOverride: 500),
    },
  );

  static const _markerAndro = CharacterAnimationConfig(
    spriteSheet: 'markerandrosheet.png',
    frameWidth:  2970 / 6,
    frameHeight: 2160 / 4,
    animations: {
      AnimationState.attack:    CharacterAnimationRow(rowIndex: 0, frameCount: 6, stepTime: 0.10),
      AnimationState.runAttack: CharacterAnimationRow(rowIndex: 1, frameCount: 6, stepTime: 0.10),
      AnimationState.idle:      CharacterAnimationRow(rowIndex: 2, frameCount: 4, stepTime: 0.20, yOffset: 20),
      AnimationState.run:       CharacterAnimationRow(rowIndex: 3, frameCount: 6, stepTime: 0.12, yOffset: 40, frameHeightOverride: 500),
    },
  );

  static const _watercolorGirl = CharacterAnimationConfig(
    spriteSheet: 'watercolorgirlsheet.png',
    frameWidth:  2925 / 6,
    frameHeight: 2160 / 4,
    animations: {
      AnimationState.attack:    CharacterAnimationRow(rowIndex: 0, frameCount: 6, stepTime: 0.10),
      AnimationState.runAttack: CharacterAnimationRow(rowIndex: 1, frameCount: 6, stepTime: 0.10),
      AnimationState.idle:      CharacterAnimationRow(rowIndex: 2, frameCount: 4, stepTime: 0.20),
      AnimationState.run:       CharacterAnimationRow(rowIndex: 3, frameCount: 6, stepTime: 0.12),
    },
  );

  static const _watercolorBoy = CharacterAnimationConfig(
    spriteSheet: 'watercolorboysheet.png',
    frameWidth:  2950 / 6,
    frameHeight: 2160 / 4,
    animations: {
      AnimationState.attack:    CharacterAnimationRow(rowIndex: 0, frameCount: 6, stepTime: 0.10),
      AnimationState.runAttack: CharacterAnimationRow(rowIndex: 1, frameCount: 6, stepTime: 0.10),
      AnimationState.idle:      CharacterAnimationRow(rowIndex: 2, frameCount: 4, stepTime: 0.20, yOffset: 20),
      AnimationState.run:       CharacterAnimationRow(rowIndex: 3, frameCount: 6, stepTime: 0.12, yOffset: 40, frameHeightOverride: 500),
    },
  );

  static const _watercolorAndro = CharacterAnimationConfig(
    spriteSheet: 'watercolorandrosheet.png',
    frameWidth:  2976 / 6,
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
      MediumType.marker: _markerGirl,
      MediumType.watercolor: _watercolorGirl,
    },
    'boy_character.png': {
      MediumType.pencil: _pencilBoy,
      MediumType.pen: _penBoy,
      MediumType.marker: _markerBoy,
      MediumType.watercolor: _watercolorBoy,
    },
    'andro_character.png': {
      MediumType.pencil: _pencilAndro,
      MediumType.pen: _penAndro,
      MediumType.marker: _markerAndro,
      MediumType.watercolor: _watercolorAndro,
    },
  };
}
