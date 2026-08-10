import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:multimedia_rogue/main.dart';
import 'package:multimedia_rogue/presentation/components/enemy/enemy_display.dart';

class PlayerContactHitbox extends CircleHitbox with HasGameReference<MyGame> {
  static const double _iframeDuration = 0.8;
  double _iframes = 0.0;

  @override
  void update(double dt) {
    super.update(dt);
    if (_iframes > 0) _iframes -= dt;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, ShapeHitbox other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other.hitboxParent is Enemy) {
      if (_iframes > 0) return;
      _iframes = _iframeDuration;
      FlameAudio.play('tear.wav');
      final wasDead = game.player.isDead;
      game.player.takeDamage(1);
      game.healthBar?.updateHealth(game.player.hp);
      game.characterDisplay?.flashHit();
      if (!wasDead && game.player.isDead) {
        game.router.pushNamed('gameover');
      }
    }
  }
}
