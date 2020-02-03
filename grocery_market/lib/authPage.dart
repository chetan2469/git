import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  GoogleSignInAccount _currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    if (_currentUser != null) {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => DashBoardPage(_handleSignOut,_currentUser)));
    } else {
      print('Log IN Failed');
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => DashBoardPage(_handleSignOut, _currentUser)));

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  // Future<void> _handleSignIn() async {
  //   try {
  //     await _googleSignIn.signIn();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.hardLight),
                image: AssetImage(
                  'assets/wallpaper.jpg',
                ),
                fit: BoxFit.fill)),
        child: Center(
          child: Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.all(30),
            child: RaisedButton(
              color: Colors.redAccent,
              onPressed: () {
                _handleSignIn();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => DemoPage(_handleSignOut,_currentUser),
                //     ));
              },
              child: Text(
                "Sign In With Google",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.redAccent)),
            ),
          ),
        ),
      ),
    );
  }
}
