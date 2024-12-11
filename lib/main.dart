//IM/2021/120 - L.S.Rajapaksha
//importing necessary libries
import 'package:cal_new/cal_screen.dart';
import 'package:flutter/material.dart';

//run the main
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // override buildContext for the root of my Cal app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}
