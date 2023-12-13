import 'package:flutter/foundation.dart';

class StateManager<T> extends ChangeNotifier {
  late T _currentState;
  List<T> states = [];

  void setCurrentState(T state) {
    _currentState = state;
    notifyListeners();
  }

  set currentState(T state) {
    setCurrentState(state);
  }

  T get currentState => _currentState;
}
