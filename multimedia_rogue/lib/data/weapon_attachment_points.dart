import 'package:flame/components.dart';
import 'package:multimedia_rogue/domain/entities/medium.dart';
import 'package:multimedia_rogue/presentation/components/character/character_animations.dart';

/// Normalized (0-1) hand attachment points per weapon, animation state, and frame.
/// x=0 = LEFT edge, x=1 = RIGHT edge. y=0 = TOP, y=1 = BOTTOM. (0.5,0.5) = center.
/// Children in Flame are positioned from the top-left of the parent bounding box.
const Map<MediumType, Map<AnimationState, List<List<double>>>> _rawAttachmentPoints = {
  MediumType.pencil: {
    AnimationState.idle: [
      [0.76, 0.57], // frame 0
      [0.76, 0.56], // frame 1
      [0.75, 0.57], // frame 2
      [0.76, 0.58], // frame 3
    ],
    // Run row (row 3): arm swings forward then back each cycle.
    // Frame 2 = arm furthest forward/up; frame 4 = arm furthest back/down.
    AnimationState.run: [
      [0.68, 0.58], // frame 0 - arm neutral/back
      [0.74, 0.52], // frame 1 - arm swinging forward
      [0.81, 0.47], // frame 2 - arm at peak forward
      [0.77, 0.51], // frame 3 - arm coming back
      [0.65, 0.60], // frame 4 - arm at peak back
      [0.63, 0.64], // frame 5 - arm down/transitioning
    ],
    AnimationState.attack: [
      [0.80, 0.48], // frame 0
      [0.86, 0.43], // frame 1
      [0.92, 0.45], // frame 2
      [0.87, 0.50], // frame 3
      [0.81, 0.53], // frame 4
      [0.76, 0.51], // frame 5
    ],
    AnimationState.runAttack: [
      [0.78, 0.50], // frame 0
      [0.84, 0.45], // frame 1
      [0.90, 0.47], // frame 2
      [0.85, 0.51], // frame 3
      [0.79, 0.55], // frame 4
      [0.74, 0.52], // frame 5
    ],
  },
};

/// Returns the weapon position in the parent's local coordinate space
/// (from top-left of bounding box). Multiply by host.size for pixel coords.
Vector2? getAttachmentPoint(
  MediumType medium,
  AnimationState state,
  int frameIndex,
) {
  final stateMap = _rawAttachmentPoints[medium];
  if (stateMap == null) return null;
  final frames = stateMap[state];
  if (frames == null || frames.isEmpty) return null;
  final pair = frames[frameIndex.clamp(0, frames.length - 1)];
  return Vector2(pair[0], pair[1]);
}
