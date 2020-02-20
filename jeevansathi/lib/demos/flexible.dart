import 'package:flutter/material.dart';

class FlexiBleDemo extends StatefulWidget {
  @override
  _FlexiBleDemoState createState() => _FlexiBleDemoState();
}

class _FlexiBleDemoState extends State<FlexiBleDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
              child: Column(
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Container(
                color: Colors.cyan,
                height: 200,
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                color: Colors.teal,
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                color: Colors.indigo,
              ),
            )
          ],
        ),
      ),
    );
  }
}
