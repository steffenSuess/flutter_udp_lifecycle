import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udp_lifecycle/components/lists/found_data_list.dart';
import 'package:flutter_udp_lifecycle/provider/lifecycle_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LifecycleProvider>(
      builder: (context, lifecycleProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FoundDataList(),
            ),
            Spacer(),
            Container(
                width: double.infinity,
                child: Text(
                  'Last notification: ${lifecycleProvider.lifecycleState}',
                  textAlign: TextAlign.center,
                )),
          ],
        );
      },
    );
  }
}
