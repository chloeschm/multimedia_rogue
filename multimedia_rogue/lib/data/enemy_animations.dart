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
  static const pencilEnemy = EnemyAnimationConfig(
    spriteSheet: 'pencilenemysheet.jpg',
    frameWidth:  3840 / 2,
    frameHeight: 2077 / 1,
    frameCount:  2,
    stepTime:    0.35,
  );
}
