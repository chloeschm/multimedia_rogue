import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/enemy/watercolor_enemy.dart';
import 'package:multimedia_rogue/presentation/components/exit_door.dart';

class WatercolorWorld extends PositionComponent with HasGameReference<MyGame> {
  WatercolorWorld() : super(priority: -10);

  @override
  Future<void> onLoad() async {
    size = game.size;
    add(_DampPaperBackground()..size = size);
    add(WatercolorEnemyDisplay());

    final door = WatercolorExitDoor(onEnter: _victory)
      ..size = Vector2(game.size.x * 0.025, game.size.y * 0.3)
      ..position = Vector2(game.size.x * 0.965, game.size.y * 0.35);
    add(door);
  }

  void _victory() {
    game.router.pushNamed('victory');
  }
}

class _DampPaperBackground extends PositionComponent {
  static const Color _paper = Color(0xFFF1EEE6);
  static const List<Color> _washes = [
    Color(0xFF7FA8C9),
    Color(0xFF9C8FBF),
    Color(0xFF7FBFA8),
    Color(0xFFC98F9C),
  ];

  final List<_Wash> _blooms = [];
  double _time = 0.0;

  @override
  Future<void> onLoad() async {
    final random = Random(23);
    for (int i = 0; i < 6; i++) {
      _blooms.add(
        _Wash(
          color: _washes[i % _washes.length],
          center: Offset(
            random.nextDouble() * size.x,
            random.nextDouble() * size.y,
          ),
          radius: size.y * (0.16 + random.nextDouble() * 0.2),
          phase: random.nextDouble() * pi * 2,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = _paper,
    );

    for (final bloom in _blooms) {
      final breath = 1.0 + 0.10 * sin(_time * 0.25 + bloom.phase);
      for (int layer = 0; layer < 2; layer++) {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(
              bloom.center.dx + sin(_time * 0.1 + bloom.phase) * 8,
              bloom.center.dy + cos(_time * 0.13 - bloom.phase) * 6,
            ),
            width: bloom.radius * 2.4 * breath * (1.0 - layer * 0.3),
            height: bloom.radius * 1.8 * breath * (1.0 - layer * 0.3),
          ),
          Paint()
            ..color = bloom.color.withOpacity(0.07 + layer * 0.05)
            ..maskFilter = MaskFilter.blur(
              BlurStyle.normal,
              26.0 - layer * 8.0,
            ),
        );
      }
    }
  }
}

class _Wash {
  final Color color;
  final Offset center;
  final double radius;
  final double phase;

  _Wash({
    required this.color,
    required this.center,
    required this.radius,
    required this.phase,
  });
}
