import 'package:multimedia_rogue/domain/entities/input_action.dart';
import 'package:multimedia_rogue/domain/repositories/input_handler.dart';
import 'dart:async';
import '../palette.dart';

class SwapMediumUseCase {
  final InputHandler inputHandler;
  final Palette palette;
  StreamSubscription? _subscription;
  void startListening() {
    _subscription = paletteStream.listen((_) {});
  }

  Stream<Palette> get paletteStream => inputHandler.inputStream
      .where((swapMedium) => swapMedium.actionType == ActionType.swapMedium)
      .map((_) {
        palette.nextMedium();
        return palette;
      });
  SwapMediumUseCase(this.inputHandler, this.palette);

  void dispose() {
    _subscription?.cancel();
  }
}
