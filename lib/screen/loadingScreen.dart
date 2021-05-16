import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SpinKitWave(color: Theme.of(context).primaryColor),
        Text('Wait for a moment', style: Theme.of(context).textTheme.bodyText1)
      ]),
    );
  }
}
