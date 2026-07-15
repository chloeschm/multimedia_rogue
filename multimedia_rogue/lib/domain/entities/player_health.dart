class PlayerHealth {
  final int maxHp;
  int _hp;

  PlayerHealth({this.maxHp = 10}) : _hp = maxHp;

  int get hp => _hp;
  bool get isDead => _hp <= 0;

  void takeDamage(int amount) => _hp = (_hp - amount).clamp(0, maxHp);
  void heal(int amount) => _hp = (_hp + amount).clamp(0, maxHp);
  void reset() => _hp = maxHp;
}
