import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';

import '../constants.dart';

class UdpProvider with ChangeNotifier {
  RawDatagramSocket _socket;
  List<String> _data = [];

  UnmodifiableListView<String> get data => UnmodifiableListView(_data);

  void clearData() {
    _data?.clear();
    notifyListeners();
  }

  startListening() async {
    if (_socket == null) {
      _socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        updPort,
      );
      _socket.handleError((error, stackTrace) {
        print('UDP Socket Error: ${error.toString()}');
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
          print('UDP Listening Error: ${error.toString()}');
        },
        onDone: () {
          _socket = null;
        },
      );
    }
  }

  void stopListening() {
    _socket?.close();
    clearData();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
