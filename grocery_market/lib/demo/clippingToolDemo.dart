import 'package:flutter/material.dart';

class ClippingToolDemo extends StatefulWidget {
  @override
  _ClippingToolDemoState createState() => _ClippingToolDemoState();
}

class _ClippingToolDemoState extends State<ClippingToolDemo> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        color: Colors.red,
      ),
      clipper:  BottomWaveClipper(),     
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path = new Path();
    path.lineTo(size.width,0);
    path.quadraticBezierTo(
      size.width/50,size.height-20,size.width/10,size.height-30
    );
    path.lineTo(0, size.height);
    path.close();
    
    return path;

    // var path = new Path();
    // path.lineTo(0, size.height);

    // var x = Offset(size.width/4, size.height-60);
    // var y = Offset(size.width/2, size.height-20);

    // path.quadraticBezierTo(x.dx, x.dy, y.dx, y.dy);

    // var sx = Offset(size.width/2, size.height-60);
    // var sy = Offset(size.width, size.height-10);

    // path.quadraticBezierTo(sx.dx, sx.dy, sy.dx, sy.dy);

    // path.lineTo(size.width, 0);
    // path.close();

    // return path;
  }
  bool shouldReclip(CustomClipper<Path>oldClipper)=> false;
}