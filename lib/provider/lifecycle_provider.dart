import 'package:flutter/material.dart';

class LifecycleProvider with ChangeNotifier {
  AppLifecycleState _lifecycleState;

  get lifecycleState => _lifecycleState;

  set lifecycleState(AppLifecycleState state) {
    _lifecycleState = state;
    notifyListeners();
  }
}
