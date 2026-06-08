import '../entities/input_action.dart';

abstract class InputHandler{
  Stream<InputAction> get inputStream;
}