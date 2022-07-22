import 'package:chedo/showMenu.dart';
import 'package:chedo/studentstream/studentDashboard.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../data/studentAdmissionRecord.dart';

class StudentAuthenticationUpdated extends StatefulWidget {
  GoogleSignInAccount? user;
  bool isGuest;
  Function signOutFromGoogle;
  StudentAuthenticationUpdated(
      {Key? key,
      required this.user,
      required this.signOutFromGoogle,
      required this.isGuest})
      : super(key: key);

  @override
  State<StudentAuthenticationUpdated> createState() =>
      _StudentAuthenticationUpdatedState();
}

class _StudentAuthenticationUpdatedState
    extends State<StudentAuthenticationUpdated> {
  bool validUser = false, processing = true, firstTimeEntry = false;
  String userPassword = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late StudentAdmissionRecord record;
  final _formKey = GlobalKey<FormState>();
  var _isLogin = false;
  bool isAdmin = false;
  var _userName = '';
  var _userPassword = '';
  String ref = '';
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.isGuest) {
      isAdminCheckFunction();
    }
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
        _isLogin = true;
        validUser = true;
      });
    } else {
      print('-------trying to isStudentRegistred');
      isStudentRegistred();
    }

    setState(() {
      processing = false;
    });
  }

  void isStudentRegistred() async {
    setState(() {
      processing = true;
    });
    DocumentSnapshot ds = await firestore
        .collection('imsStudentUsers')
        .doc(widget.user!.email.toString())
        .get();
    if (ds.exists) {
      print('user found_____');

      var ds = await firestore
          .collection('imsStudentUsers')
          .doc(widget.user!.email.toString())
          .get();

      if (ds.exists) {
        Map<String, dynamic>? data = ds.data();
        setState(() {
          ref = data?['admissionref'];
        });

        print(ref + "_________________REFFFF__________________________");

        setState(() {
          _isLogin = true;
          validUser = true;
          processing = false;
        });
      }
    } else {
      print('-------trying to get user entry from adminssion');
      findStudentDataByEmail();
    }
  }

  findStudentDataByEmail() async {
    setState(() {
      processing = true;
      firstTimeEntry = true;
    });

    print('________________ trying to check user ________________________');
    final QuerySnapshot result = await firestore
        .collection('admission')
        .where('studentMail', isEqualTo: widget.user!.email.toString())
        .get();
    print(result.docs.length.toString());
    if (result.docs.length == 1) {
      setState(() {
        validUser = true;
        ref = result.docs[0].id;
      });
      print(result.docs[0].reference);
      for (var data in result.docs) {
        setState(() {
          record = StudentAdmissionRecord(
              aadharno: (data as dynamic)['aadharNo'],
              addDate: (data as dynamic)['addDate'],
              address: (data as dynamic)['address'],
              batchtime: (data as dynamic)['batchTime'],
              courses: (data as dynamic)['courses'],
              dateofbirth: (data as dynamic)['dateOfBirth'],
              imageurl: (data as dynamic)['imageUrl'],
              mobileno: (data as dynamic)['mobileNo'],
              name: (data as dynamic)['name'],
              optionalno: (data as dynamic)['optNumber'],
              outStandingAmount: (data as dynamic)['outStandingAmount'],
              pursuing_course: (data as dynamic)['pursuing_course'],
              reference: data.reference,
              status: (data as dynamic)['status']);
        });
        print('______________' + record.reference.toString());
      }
      print('________________ data success ________________________');
      setState(() {
        validUser = true;
        processing = false;
      });
      firstTimeStudentEntry();
    }
  }

  firstTimeStudentEntry() async {
    setState(() {
      processing = false;
    });
    print('_________ trying insert___________');
    FirebaseFirestore.instance
        .collection('imsStudentUsers')
        .doc(widget.user!.email.toString())
        .set({'admissionref': record.reference.id});
    print('_________sucees insert___________');
  }

  @override
  Widget build(BuildContext context) {
    if (isAdmin) {
      return ShowMenu(widget.signOutFromGoogle, widget.user);
    } else if (validUser) {
      return StudentDashboard(widget.user, widget.signOutFromGoogle, ref);
    } else if (widget.isGuest) {
      return StudentDashboard(
          widget.user, widget.signOutFromGoogle, 'xReQTZ8R7Mvg88o4HIxH');
    }
    return DelayedDisplay(
      delay: Duration(seconds: 2),
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 5),
                child: Image.asset(
                  'images/chedo.png',
                  width: MediaQuery.of(context).size.width / 3,
                )),
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                'May be, you are not authenticated Chedo student, Contact institute Management if you want to use this app. this app is only for Chedo Students. ',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      widget.signOutFromGoogle();
                    },
                    child: Text('<-- logout')),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                ),
                ElevatedButton(
                    onPressed: () {
                      print('Guest Entry...');
                      setState(() {
                        widget.isGuest = true;
                      });
                      insertGuestEntry();
                    },
                    child: Text('login as guest -->'))
              ],
            )
          ],
        ),
      ),
    );
  }

  void insertGuestEntry() async {
    await firestore
        .collection('guestEntry')
        .doc()
        .set({'email': widget.user?.email.toString(), 'time': Timestamp.now()});
  }
}
