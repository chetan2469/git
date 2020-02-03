import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project1/authPage.dart';
import 'package:project1/constant.dart';

class DemoPage extends StatefulWidget {
  final Function handleSignOut;
  final GoogleSignInAccount _currentUser;
  DemoPage(this.handleSignOut,this._currentUser);
  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  FirebaseUser user;
  String photoUrl;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cFireBaseAuth.currentUser().then((user)=>setState((){
      this.user=user;
      photoUrl = user.photoUrl;
    }));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TestDemo Page"),),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
              ),
            ),
            Container(
              child: RaisedButton(
                child: Text("Sign Out"),
                onPressed: (){
                  widget.handleSignOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AuthPage()));
                },
              ),
            ),
          ],
        )
      ),
    );
  }
}

  // ClipPath(
  //           child: Center(
  //             child: Container(
  //               height: 30,
  //               color: Colors.red,
  //             ),
  //           ),
  //           clipper: BottomWaveClipper(),
  //         ),