import 'package:flutter/material.dart';
import 'package:institute_management_system/animation.dart';
import 'package:institute_management_system/auth.dart';

import 'hero/HeroFirstAnimation.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "IMS",
      home: Auth(),
    );
  }
}