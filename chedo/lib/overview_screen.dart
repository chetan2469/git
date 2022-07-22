// ignore_for_file: must_be_immutable, avoid_print

import 'package:chedo/showMenu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'studentstream/studentDashboard.dart';

class OverviewScreen extends StatefulWidget {
  Function signOutFromGoogle;
  GoogleSignInAccount? user;
  OverviewScreen(this.user, this.signOutFromGoogle, {Key? key})
      : super(key: key);

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  String ref = '';
  bool processing = true;
  bool isAdmin = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    print(widget.user?.email.toString());
    isAdminCheckFunction();
  }

  isAdminCheckFunction() async {
    setState(() {
      processing = true;
    });
    var collection = FirebaseFirestore.instance.collection('imsAdmin');
    var docSnapshot = await collection.doc(widget.user!.email.toString()).get();
    if (docSnapshot.exists) {
      setState(() {
        isAdmin = true;
      });
    } else {
      getDocRef();
    }

    setState(() {
      processing = false;
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    widget.signOutFromGoogle();
  }

  getDocRef() async {
    print('getDocRef called...');
    setState(() {
      processing = true;
    });
    var collection = FirebaseFirestore.instance.collection('imsStudentUsers');
    var docSnapshot = await collection.doc(widget.user!.email.toString()).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();

      setState(() {
        ref = data?['admissionref'];
      });
    }

    setState(() {
      processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: isAdmin
              ? ShowMenu(widget.signOutFromGoogle, widget.user)
              : ref.isNotEmpty
                  ? StudentDashboard(widget.user, widget.signOutFromGoogle, ref)
                  : Container()),
    );
  }
}
