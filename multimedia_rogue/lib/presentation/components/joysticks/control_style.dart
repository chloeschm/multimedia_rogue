import 'dart:ui';

import 'package:multimedia_rogue/domain/entities/medium.dart';

class ControlStyle {
  final Color color;
  final double blurScale;
  final double strokeScale;
  final double knobScale;
  final bool drips;

  const ControlStyle({
    required this.color,
    required this.blurScale,
    this.strokeScale = 1.0,
    this.knobScale = 1.0,
    this.drips = false,
  });

  double blur(double base) => (base * blurScale).clamp(0.2, 40.0);

  static ControlStyle of(MediumType? medium) {
    switch (medium) {
      case MediumType.pen:
        return const ControlStyle(
          color: Color(0xFF1B2430),
          blurScale: 0.35,
          strokeScale: 0.8,
          knobScale: 0.85,
        );
      case MediumType.marker:
        return const ControlStyle(
          color: Color(0xFF2C7FE0),
          blurScale: 0.15,
          strokeScale: 2.4,
          knobScale: 1.35,
        );
      case MediumType.watercolor:
        return const ControlStyle(
          color: Color(0xFF4A7BA6),
          blurScale: 1.9,
          strokeScale: 1.5,
          knobScale: 1.15,
          drips: true,
        );
      default:
        return const ControlStyle(color: Color(0xFF3A3A3A), blurScale: 1.0);
    }
  }
}
