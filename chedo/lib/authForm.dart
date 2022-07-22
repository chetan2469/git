// ignore_for_file: file_names, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:get/get.dart';

import 'data/studentAdmissionRecord.dart';
import 'googleSignInPage.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  GoogleSignInAccount? user;
  final bool isLoading;
  Function signOutFromGoogle;

  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  AuthForm(
      {Key? key,
      required this.isLoading,
      required this.submitFn,
      this.user,
      required this.signOutFromGoogle})
      : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool validUser = false, processing = true, firstTimeEntry = false;
  String userPassword = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late StudentAdmissionRecord record;
  final _formKey = GlobalKey<FormState>();
  var _isLogin = false;
  bool isAdmin = false;
  var _userName = '';
  var _userPassword = '';
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    isAdminCheckFunction();
    super.initState();
    setState(() {
      emailController.text = widget.user!.email;
      _userName = widget.user!.email.split('@')[0];
    });
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
      //  print('user found_____');

      DocumentSnapshot dd = await firestore
          .collection('imsStudentUsers')
          .doc(widget.user!.email.toString())
          .get();
      try {
        userPassword = (dd as dynamic)['password'];
        setState(() {
          _isLogin = true;
          validUser = true;
        });
      } catch (e) {
        //  print('password is not set');
        setState(() {
          _isLogin = false;
          validUser = true;
          processing = false;
        });
      }
    } else {
      //  print('user not found');
      setState(() {
        _isLogin = false;
        processing = false;
      });
      findStudentDataByEmail();
    }
    setState(() {
      processing = false;
    });
  }

  findStudentDataByEmail() async {
    setState(() {
      processing = true;
      firstTimeEntry = true;
    });
    //  print('________________ trying to check user ________________________');
    final QuerySnapshot result = await firestore
        .collection('admission')
        .where('studentMail', isEqualTo: widget.user!.email.toString())
        .get();
    //  print(result.docs.length.toString());
    if (result.docs.length == 1) {
      setState(() {
        validUser = true;
      });
      for (var data in result.docs) {
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
      }
      //  print('________________ data success ________________________');
      setState(() {
        validUser = true;
        processing = false;
      });
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
        .set({
      'admissionref': record.reference.id,
      'password': _userPassword.trim()
    });
    print('_________sucees insert___________');
    Get.to(GoogleSignInPage());
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (firstTimeEntry && isValid) {
      firstTimeStudentEntry();
    } else if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(emailController.text.trim(), _userPassword.trim(),
          _userName.trim(), _isLogin, context);
      //  print('__________******________***********');
    } else if (_isLogin == false) {
      firestore
          .collection('imsStudentUsers')
          .doc(widget.user!.email.toString())
          .update({'password': _userPassword.trim()});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: !processing
              ? Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 10, bottom: 10),
                  child: validUser
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            CachedNetworkImage(
                                imageUrl:
                                    'https://firebasestorage.googleapis.com/v0/b/flutter-chedo.appspot.com/o/logo-min.png?alt=media&token=5677da0f-1900-48e2-a427-869a4a90cff9'),
                            ListTile(
                              leading: GoogleUserCircleAvatar(
                                backgroundColor: Colors.white,
                                identity: widget.user!,
                              ),
                              title: Text(widget.user!.displayName ?? ''),
                              subtitle: Text(widget.user!.email),
                            ),
                            const SizedBox(height: 10.0),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                key: const ValueKey('password'),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  labelText: _isLogin
                                      ? 'Enter 6 digit Password'
                                      : 'Set 6 digit Password',
                                  labelStyle: const TextStyle(
                                      fontFamily: 'RobotoCondensed',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green)),
                                ),
                                obscureText: true,

                                // ignore: missing_return
                                validator: (value) {
                                  if (value!.isEmpty || value.length != 6) {
                                    return 'Please enter 6 digit password';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userPassword = value!;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            if (widget.isLoading)
                              const Center(child: CircularProgressIndicator()),
                            if (!widget.isLoading)
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.2,
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: SignInButtonBuilder(
                                          text: 'back',
                                          icon: Icons.arrow_back,
                                          onPressed: () {
                                            widget.signOutFromGoogle();
                                          },
                                          backgroundColor:
                                              Colors.blueGrey[700]!,
                                        )),
                                    Expanded(child: Container()),
                                    Expanded(
                                        flex: 4,
                                        child: SignInButtonBuilder(
                                          text: 'continue',
                                          icon: Icons.arrow_forward_ios,
                                          onPressed: _trySubmit,
                                          backgroundColor: Colors.blue,
                                        )),
                                  ],
                                ),
                              ),
                          ],
                        )
                      : Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: const Text(
                                  "This is not valid chedo student account logout from here and try diffrent google account or ask help to your trainer",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red)),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              height: 57.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.black,
                                color: const Color.fromRGBO(111, 105, 172, 1),
                                elevation: 10.0,
                                child: TextButton(
                                  onPressed: () {
                                    widget.signOutFromGoogle();
                                  },
                                  child: const Center(
                                    child: Text(
                                      "login with diffrent mail",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Raleway'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
