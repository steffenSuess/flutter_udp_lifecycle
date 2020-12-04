import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udp_lifecycle/provider/udp_provider.dart';
import 'package:provider/provider.dart';

class FoundDataList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UdpProvider>(
      builder: (context, udpProvider, child) {
        return udpProvider.data.length > 0
            ? ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(udpProvider.data[index]),
                  );
                },
                itemCount: udpProvider.data.length,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(),
                  Text('Searching'),
                ],
              );
      },
    );
  }
}
