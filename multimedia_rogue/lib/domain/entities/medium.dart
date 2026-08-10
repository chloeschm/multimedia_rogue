enum MediumType {
  pencil,
  pen,
  marker,
  watercolor,
  // brush,
  // pastel,
}

class Medium {
  final MediumType type;
  final double damage;
  final double speed;
  final String effectName;

  Medium({
    required this.type,
    required this.damage,
    required this.speed,
    required this.effectName,
  });
}
