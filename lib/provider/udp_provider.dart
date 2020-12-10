import 'dart:collection';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class UdpProvider with ChangeNotifier {
  RawDatagramSocket _socket;
  List<String> _data = [];

  UnmodifiableListView<String> get data => UnmodifiableListView(_data);

  void clearData() {
    _data?.clear();
    notifyListeners();
    FirebaseCrashlytics.instance.log('UdpProvider data cleared');
  }

  startListening() async {
    if (_socket == null) {
      _socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        updPort,
      );
      _socket.handleError((error, stackTrace) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
      });
      _socket.listen(
        (event) {
          if (event == RawSocketEvent.read) {
            var data = String.fromCharCodes(_socket.receive().data);
            _data.add(data);
            print(data);
            notifyListeners();
          }
        },
        onError: (error, stackTrace) {
          FirebaseCrashlytics.instance.recordError(error, stackTrace);
        },
        onDone: () {
          FirebaseCrashlytics.instance.log("Socket onDone");
        },
      );
    }
    FirebaseCrashlytics.instance.log("started Listening");
  }

  void stopListening() {
    _socket?.close();
    clearData();
    FirebaseCrashlytics.instance.log("stopped Listening");
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
    FirebaseCrashlytics.instance.log("UdpProvider disposed");
  }
}
