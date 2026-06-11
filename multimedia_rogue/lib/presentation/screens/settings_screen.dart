import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/widgets.dart';
import 'package:multimedia_rogue/presentation/components/back_button.dart';
import 'package:multimedia_rogue/presentation/components/slider_bar.dart';
import 'package:multimedia_rogue/presentation/components/slider_handle.dart';
import 'package:multimedia_rogue/presentation/components/volume_label.dart';
import '../mixins/page_screen.dart';

class SettingsScreen extends PageScreen with TapCallbacks {
  @override
  Future<void> onLoad() async {
    await super.onLoad();


    final backButton = BackButton(
      onPressed: _animateOut,
    );
    backButton.size = Vector2(paperSize.x * 0.18, paperSize.y * 0.07);
    backButton.position = Vector2(
      paperPosition.x + paperSize.x * 0.03,
      paperPosition.y + paperSize.y * 0.82,
    );
    add(backButton);

    final volumeLabel = VolumeLabel();
    volumeLabel.size = Vector2(paperSize.x * 0.35, paperSize.y * 0.10);
    volumeLabel.position = Vector2(
      paperPosition.x + (paperSize.x - volumeLabel.size.x) / 2,
      paperPosition.y + paperSize.y * 0.30,
    );
    add(volumeLabel);

    final sliderWidth = paperSize.x * 0.65;
    final sliderHeight = paperSize.y * 0.07;
    final sliderX = paperPosition.x + (paperSize.x - sliderWidth) / 2;
    final sliderY = paperPosition.y + paperSize.y * 0.48;

    final sliderBar = SliderBar();
    sliderBar.size = Vector2(sliderWidth, sliderHeight);
    sliderBar.position = Vector2(sliderX, sliderY);
    add(sliderBar);

    final circleSize = paperSize.y * 0.09;
    final handle = SliderHandle(
      sliderLeft: sliderX,
      sliderRight: sliderX + sliderWidth,
    );
    handle.size = Vector2(circleSize, circleSize);
    handle.position = Vector2(
      sliderX + sliderWidth * 0.5 - circleSize / 2,
      sliderY + sliderHeight / 2 - circleSize / 2,
    );
    add(handle);
  }

  @override
  void onMount() {
    super.onMount();
    scale = Vector2(0, 1);
    add(
      ScaleEffect.to(
        Vector2(1, 1),
        EffectController(duration: 0.5, curve: Curves.easeOut),
      ),
    );
  }

  void _animateOut() {
    final effect = ScaleEffect.to(
      Vector2(0, 1),
      EffectController(duration: 0.3, curve: Curves.easeIn),
    );
    effect.onComplete = () => game.router.pop();
    add(effect);
  }
}
