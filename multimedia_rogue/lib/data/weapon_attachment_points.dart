import 'package:flame/components.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/presentation/components/character/character_animations.dart';

const Map<MediumType, Map<AnimationState, List<List<double>>>> _rawAttachmentPoints = {
  MediumType.pencil: {
    AnimationState.idle: [
      [0.76, 0.57],
      [0.76, 0.56],
      [0.75, 0.57],
      [0.76, 0.58],
    ],
    AnimationState.run: [
      [0.68, 0.58],
      [0.74, 0.52],
      [0.81, 0.47],
      [0.77, 0.51],
      [0.65, 0.60],
      [0.63, 0.64],
    ],
    AnimationState.attack: [
      [0.80, 0.48],
      [0.86, 0.43],
      [0.92, 0.45],
      [0.87, 0.50],
      [0.81, 0.53],
      [0.76, 0.51],
    ],
    AnimationState.runAttack: [
      [0.78, 0.50],
      [0.84, 0.45],
      [0.90, 0.47],
      [0.85, 0.51],
      [0.79, 0.55],
      [0.74, 0.52],
    ],
  },
};

Vector2? getAttachmentPoint(
  MediumType medium,
  AnimationState state,
  int frameIndex,
) {
  final stateMap = _rawAttachmentPoints[medium];
  final fallbackMap = _rawAttachmentPoints[MediumType.pencil];
  final frames = stateMap?[state] ?? fallbackMap?[state];
  if (frames == null || frames.isEmpty) return null;
  final pair = frames[frameIndex.clamp(0, frames.length - 1)];
  return Vector2(pair[0], pair[1]);
}
