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
      child: AppLifecycleReactor(),
    );
  }
}
