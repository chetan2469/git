import 'package:flutter/material.dart';

class StackDemo extends StatefulWidget {
  @override
  _StackDemoState createState() => _StackDemoState();
}

class _StackDemoState extends State<StackDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/wallpaper.jpg'),fit: BoxFit.cover)
              ),
            ),
           Positioned(
             left: 200,
             top: 200,
             child:  Container(
              height: 100,
              width: 100,
              color: Colors.blueAccent,
              child: TextField(),
            ),
           )
          ],
        )     
    );
  }
}