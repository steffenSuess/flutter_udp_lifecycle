import 'package:flutter/material.dart';
import 'package:flutter_udp_lifecycle/provider/lifecycle_provider.dart';
import 'package:flutter_udp_lifecycle/provider/udp_provider.dart';
import 'package:flutter_udp_lifecycle/screen/home_screen.dart';
import 'package:provider/provider.dart';

class AppLifecycleReactor extends StatefulWidget {
  @override
  _AppLifecycleReactorState createState() => _AppLifecycleReactorState();
}

class _AppLifecycleReactorState extends State<AppLifecycleReactor>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
    var udpProvider = Provider.of<UdpProvider>(context, listen: false);
    Provider.of<LifecycleProvider>(context, listen: false).lifecycleState =
        state;
    switch (state) {
      case AppLifecycleState.detached:
        udpProvider.stopListening();
        break;
      case AppLifecycleState.inactive:
        udpProvider.stopListening();
        break;
      case AppLifecycleState.paused:
        udpProvider.stopListening();
        break;
      case AppLifecycleState.resumed:
        udpProvider.startListening();
        break;
      default:
        udpProvider.stopListening();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(child: HomeScreen()),
      ),
    );
  }
}
