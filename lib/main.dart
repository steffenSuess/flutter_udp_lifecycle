import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udp_lifecycle/provider/lifecycle_provider.dart';
import 'package:flutter_udp_lifecycle/provider/udp_provider.dart';
import 'package:provider/provider.dart';

import 'components/app_lifecycle_reactor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LifecycleProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UdpProvider(),
        ),
      ],
      child: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: Text(snapshot.error.toString()),
                  ),
                ),
              );
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return AppLifecycleReactor();
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(),
                ),
              ),
            );
          }),
    );
  }
}
