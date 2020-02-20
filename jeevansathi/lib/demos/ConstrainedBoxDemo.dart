import 'package:flutter/material.dart';

class ConstrainedBoxDemo extends StatefulWidget {
  @override
  _ConstrainedBoxDemoState createState() => _ConstrainedBoxDemoState();
}

class _ConstrainedBoxDemoState extends State<ConstrainedBoxDemo> {
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Container(
      child: Switch(
        value: value,
        onChanged: (bool b) {
          setState(() {
            value = b;
          });
        },
      ),
    )));
  }
}
