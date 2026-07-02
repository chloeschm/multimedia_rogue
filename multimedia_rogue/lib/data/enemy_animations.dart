/// Enemy animation configs. Not yet wired into the game world —
/// add to an EnemyComponent when ready.
class EnemyAnimationConfig {
  final String spriteSheet;
  final double frameWidth;
  final double frameHeight;
  final int frameCount;
  final double stepTime;

  const EnemyAnimationConfig({
    required this.spriteSheet,
    required this.frameWidth,
    required this.frameHeight,
    required this.frameCount,
    required this.stepTime,
  });
}

class EnemyAnimations {
  /// Pencil scribble-blob enemy — two frames (squished / tall), loops like a slime.
  static const pencilEnemy = EnemyAnimationConfig(
    spriteSheet: 'pencilenemysheet.jpg',
    frameWidth:  3840 / 2,   // 2 frames side by side
    frameHeight: 2077 / 1,   // single row
    frameCount:  2,
    stepTime:    0.35,        // slow bounce
  );
}
