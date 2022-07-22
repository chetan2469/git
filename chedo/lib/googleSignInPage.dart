// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs, avoid_print

import 'dart:async';
import 'package:chedo/studentstream/StudentAuthenticationUpdated.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();

class GoogleSignInPage extends StatefulWidget {
  const GoogleSignInPage({Key? key}) : super(key: key);

  @override
  State createState() => GoogleSignInPageState();
}

class GoogleSignInPageState extends State<GoogleSignInPage> {
  bool isGuest = false;
  GoogleSignInAccount? _currentUser;
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    //  _handleSignOut();
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  void signOutFromGoogle() {
    _handleSignOut();
  }

  void loginToFirebase() {
    // print(_currentUser!.email.toString());
    // print(passwordController.text);
  }

  Widget _buildBody() {
    GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          return StudentAuthenticationUpdated(
            user: _currentUser,
            signOutFromGoogle: signOutFromGoogle,
            isGuest: isGuest,
          );
        },
      );
    } else {
      return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Image.asset(
                    'images/chedo.png',
                    width: MediaQuery.of(context).size.width / 3,
                  )),
              Container(
                margin: const EdgeInsets.only(top: 3, bottom: 0),
                child: const Text(
                  'Chedo Tech',
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 0, bottom: 30),
                child: const Text(
                  'Educational Institute',
                  style: TextStyle(fontSize: 22),
                ),
              ),
              SignInButton(
                Buttons.Google,
                onPressed: _handleSignIn,
                text: 'signin as Student',
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildBody(),
    );
  }
}
