import 'dart:async';
import 'dart:convert' show json;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jeevansathi/constants/constants.dart';
import 'package:jeevansathi/showMenu.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();

class SignInG extends StatefulWidget {
  @override
  State createState() => SignInGState();
}

class SignInGState extends State<SignInG> {
  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    if (_currentUser != null) {
      return ShowMenu(_handleSignOut);
    } else {
      return Column(
        children: <Widget>[
          SafeArea(
            child: SizedBox(
              height: 20,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                Container(
                  height: 67,
                  width: 65,
                  margin: EdgeInsets.only(right: 232),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    image: DecorationImage(
                      image: AssetImage('assets/sak.png'),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: '',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '\n',
                          style: GoogleFonts.kaushanScript(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          )),
                      TextSpan(
                          text: 'Somvanshi Arya Kshatriya\n',
                          style: GoogleFonts.kaushanScript(
                            fontWeight: FontWeight.w500,
                            fontSize: 26,
                          )),
                      TextSpan(
                          text: 'Matrimonial Portal',
                          style: GoogleFonts.kaushanScript(
                            fontWeight: FontWeight.w300,
                            fontSize: 24,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              height: 300,
              width: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/couple.png'),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                Container(
                  height: 53,
                  width: 300,
                  decoration: BoxDecoration(
                    //blue
                    color: Color.fromRGBO(62, 93, 187, 1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Color.fromRGBO(62, 93, 187, 1),
                          ),
                        ),
                        height: 70,
                        width: 47,
                        child: Icon(
                          FontAwesomeIcons.facebookF,
                          size: 16,
                          color: Color.fromRGBO(62, 93, 187, 1),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Continue with Facebook',
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 53,
                  width: 300,
                  margin: EdgeInsets.only(top: 17),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 64, 76, 1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: InkWell(
                    onTap: _handleSignIn,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.white,
                              border: Border.all(
                                width: 1,
                                color: Color.fromRGBO(255, 64, 76, 1),
                              ),
                            ),
                            height: 70,
                            width: 47,
                            child: Icon(
                              FontAwesomeIcons.google,
                              size: 16,
                              color: Color.fromRGBO(255, 64, 76, 1),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40),
                            child: Text(
                              'Continue with Gmail',
                              style: GoogleFonts.varelaRound(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 82, top: 20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Dont Have an account? ',
                          style: GoogleFonts.varelaRound(),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.varelaRound(
                            textStyle: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: _buildBody(),
    ));
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await cFirebaseAuth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}
