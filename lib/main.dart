import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udp_lifecycle/provider/lifecycle_provider.dart';
import 'package:flutter_udp_lifecycle/provider/udp_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'components/app_lifecycle_reactor.dart';

// Toggle this to cause an async error to be thrown during initialization
// and to test that runZonedGuarded() catches the error
final _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
final _kTestingCrashlytics = true;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stackTrace) {
    print('runZonedGuarded: Caught error in my root zone.');
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      print(list[100]);
    });
  }

  // Define an async function to initialize FlutterFire
  Future<void> _initializeFlutterFire() async {
    // Wait for Firebase to initialize
    await Firebase.initializeApp();

    if (_kTestingCrashlytics) {
      // Force enable crashlytics collection enabled if we're testing it.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      // Else only enable it in non-debug builds.
      // You could additionally extend this to allow users to opt-in.
      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(!kDebugMode);
    }

    FirebaseCrashlytics.instance
        .setUserIdentifier((await _getId()) ?? Uuid().v4());

    // Pass all uncaught errors to Crashlytics.
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };

    if (_kShouldTestAsyncErrorOnInit) {
      await _testAsyncErrorOnInit();
    }
  }

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
          future: _initializeFlutterFire(),
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

Future<String> _getId() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    // import 'dart:io'
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  } else {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId; // unique ID on Android
  }
}
