import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:multimedia_rogue/main.dart';

class HealthBar extends SpriteComponent with HasGameReference<MyGame> {
  static const Color _glowGreen = Color(0xFF6FBF73);
  static const Color _arrowGreen = Color(0xFF2E7D32);
  static const double _fxDuration = 1.8;

  final List<Sprite> _sprites = [];
  double _healFx = 0.0;

  @override
  Future<void> onLoad() async {
    for (int i = 0; i <= 10; i++) {
      _sprites.add(await Sprite.load('health$i.png'));
    }
    sprite = _sprites[10];
  }

  void updateHealth(int hp) {
    sprite = _sprites[hp.clamp(0, 10)];
  }

  void highlightHeal() => _healFx = _fxDuration;

  @override
  void update(double dt) {
    super.update(dt);
    if (_healFx > 0) _healFx -= dt;
  }

  @override
  void render(Canvas canvas) {
    final t = (_healFx / _fxDuration).clamp(0.0, 1.0);

    if (t > 0) {
      final pulse = 0.6 + 0.4 * (0.5 + 0.5 * sin(_healFx * 12));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-7, -7, size.x + 14, size.y + 14),
          const Radius.circular(10),
        ),
        Paint()
          ..color = _glowGreen.withOpacity((0.40 * t * pulse).clamp(0.0, 1.0))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
      );
    }

    super.render(canvas);

    if (t > 0) {
      final bob = sin(_healFx * 8) * 6;
      final ax = size.x + 16 + bob;
      final ay = size.y / 2;
      final arrow = Path()
        ..moveTo(ax, ay)
        ..lineTo(ax + 13, ay - 9)
        ..lineTo(ax + 13, ay - 3.5)
        ..lineTo(ax + 28, ay - 3.5)
        ..lineTo(ax + 28, ay + 3.5)
        ..lineTo(ax + 13, ay + 3.5)
        ..lineTo(ax + 13, ay + 9)
        ..close();
      canvas.drawPath(
        arrow,
        Paint()..color = _arrowGreen.withOpacity((0.9 * t).clamp(0.0, 1.0)),
      );
    }
  }
}
