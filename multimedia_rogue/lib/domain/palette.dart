import 'entities/medium.dart';

class Palette {
  final List<Medium> _mediums;
  int _activeMedium;
  Palette({required List<Medium> mediums, required int activeMedium})
      : _mediums = mediums,
        _activeMedium = activeMedium;

  void addMedium(Medium medium) {
    _mediums.add(medium);

    if (_mediums.isEmpty) {
      _activeMedium = 0;
    }
  }

  void switchMedium(int newMedium) {
    _activeMedium = newMedium;
    if (_activeMedium >= _mediums.length) {
      _activeMedium = 0;
    }
  }

  void nextMedium() {
    switchMedium(_activeMedium + 1);
  }

  Medium get currentMedium {
    return _mediums[_activeMedium];
  }
}
