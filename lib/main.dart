import 'package:flutter/material.dart';
import 'package:scan_n_vote/constants.dart';
import 'package:scan_n_vote/screens/initial/initial_screen.dart';
import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scan-N-Vote',
      theme: ThemeData(
        scaffoldBackgroundColor: backdropColor,
      ),
      home: InitialScreen(),
    );
  }
}
