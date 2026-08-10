import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/enemy/pen_enemy.dart';
import 'package:multimedia_rogue/presentation/components/exit_door.dart';
import 'package:multimedia_rogue/presentation/world_overlays/marker_world.dart';

class PenWorld extends PositionComponent with HasGameReference<MyGame> {
  PenWorld() : super(priority: -10);

  @override
  Future<void> onLoad() async {
    size = game.size;
    add(_DraftingPaperBackground()..size = size);
    add(PenEnemyDisplay());

    final door = PenExitDoor(onEnter: _enterMarkerWorld)
      ..size = Vector2(game.size.x * 0.025, game.size.y * 0.3)
      ..position = Vector2(game.size.x * 0.975, game.size.y * 0.35);
    add(door);
  }

  void _enterMarkerWorld() {
    final screen = parent;
    if (screen == null) return;
    (game.characterDisplay as PositionComponent?)?.position = Vector2(
      game.size.x * 0.08,
      game.size.y * 0.55,
    );
    screen.add(MarkerWorld());
    removeFromParent();
  }
}

class _DraftingPaperBackground extends PositionComponent {
  static const Color _vellum = Color(0xFFF7F2E4);
  static const Color _blueprint = Color(0xFF7B93B5);
  static const Color _ink = Color(0xFF1B2430);

  static const double _gridSpacing = 52.0;
  static const int _stainCount = 5;

  final List<_InkStain> _stains = [];
  double _time = 0.0;

  @override
  Future<void> onLoad() async {
    final random = Random(7);
    for (int i = 0; i < _stainCount; i++) {
      final edgeBias = random.nextBool()
          ? random.nextDouble() * 0.18
          : 0.82 + random.nextDouble() * 0.18;
      _stains.add(
        _InkStain(
          center: Vector2(
            random.nextBool()
                ? edgeBias * size.x
                : random.nextDouble() * size.x,
            random.nextBool()
                ? edgeBias * size.y
                : random.nextDouble() * size.y,
          ),
          baseRadius: size.y * (0.05 + random.nextDouble() * 0.07),
          phase: random.nextDouble() * pi * 2,
          drift: random.nextDouble() * 0.4 + 0.1,
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
      Paint()..color = _vellum,
    );

    final gridPaint = Paint()
      ..color = _blueprint.withOpacity(0.10)
      ..strokeWidth = 0.8;
    for (double x = 0; x <= size.x; x += _gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.y), gridPaint);
    }
    for (double y = 0; y <= size.y; y += _gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.x, y), gridPaint);
    }

    _renderHatchVignette(canvas);

    for (final stain in _stains) {
      final breath =
          1.0 + 0.08 * sin(_time * stain.drift + stain.phase);
      final radius = stain.baseRadius * breath;
      for (int layer = 0; layer < 3; layer++) {
        canvas.drawCircle(
          Offset(
            stain.center.x + sin(_time * 0.2 + stain.phase + layer) * 3,
            stain.center.y + cos(_time * 0.17 + stain.phase - layer) * 3,
          ),
          radius * (1.0 - layer * 0.22),
          Paint()
            ..color = _ink.withOpacity(0.030 + layer * 0.018)
            ..maskFilter = MaskFilter.blur(
              BlurStyle.normal,
              14.0 - layer * 3.0,
            ),
        );
      }
    }
  }

  void _renderHatchVignette(Canvas canvas) {
    final band = size.x * 0.12;
    final hatchPaint = Paint()
      ..color = _ink.withOpacity(0.05)
      ..strokeWidth = 1.7;
    const step = 26.0;

    for (double d = -size.y; d < size.x; d += step) {
      final depth = _edgeDepth(d, band);
      if (depth <= 0) continue;
      hatchPaint.color = _ink.withOpacity(0.02 + 0.05 * depth);
      canvas.drawLine(
        Offset(d, 0),
        Offset(d + size.y, size.y),
        hatchPaint,
      );
      canvas.drawLine(
        Offset(size.x - d, 0),
        Offset(size.x - d - size.y, size.y),
        hatchPaint,
      );
    }
  }

  double _edgeDepth(double d, double band) {
    final distLeft = d.abs();
    final distRight = (size.x - d).abs();
    final nearest = min(distLeft, distRight);
    if (nearest > band * 3) return 0;
    return (1.0 - nearest / (band * 3)).clamp(0.0, 1.0);
  }
}

class _InkStain {
  final Vector2 center;
  final double baseRadius;
  final double phase;
  final double drift;

  _InkStain({
    required this.center,
    required this.baseRadius,
    required this.phase,
    required this.drift,
  });
}
