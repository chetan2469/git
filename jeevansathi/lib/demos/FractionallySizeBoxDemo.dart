import 'package:flutter/material.dart';

class FractionallySizedBoxDemo extends StatefulWidget {
  @override
  _FractionallySizedBoxDemoState createState() => _FractionallySizedBoxDemoState();
}

class _FractionallySizedBoxDemoState extends State<FractionallySizedBoxDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          heightFactor: 0.3,
          child: Container(
            color: Colors.indigo,
          ),
        ),
      ),
    );
  }
}