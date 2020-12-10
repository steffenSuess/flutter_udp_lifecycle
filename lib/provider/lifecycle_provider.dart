import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class LifecycleProvider with ChangeNotifier {
  AppLifecycleState _lifecycleState;

  get lifecycleState => _lifecycleState;

  set lifecycleState(AppLifecycleState state) {
    _lifecycleState = state;
    FirebaseCrashlytics.instance.log(state.toString());
    notifyListeners();
  }
}
