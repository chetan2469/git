import 'package:flutter/material.dart';

class MenuIconsPage extends StatefulWidget {
  @override
  _MenuIconsPageState createState() => _MenuIconsPageState();
}

class _MenuIconsPageState extends State<MenuIconsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Container(
          color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 30,
                height: 7,
                color: Colors.white,
              ),

              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: ClipPath(
                  child: Container(
                    height: 7,
                    color: Colors.white,
                  ),
                  clipper: DawerI2(),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}


class DawerI2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(size.width /2, 0);
    path.lineTo(
      size.width / 4,
      size.height,
    );
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
