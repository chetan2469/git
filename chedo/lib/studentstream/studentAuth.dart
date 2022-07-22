// ignore_for_file: must_be_immutable, avoid_print, avoid_unnecessary_containers

import 'package:chedo/data/studentAdmissionRecord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentAuth extends StatefulWidget {
  final GoogleSignInAccount? _currentUser;
  Function handleSignout;

  StudentAuth(this._currentUser, this.handleSignout, {Key? key})
      : super(key: key);

  @override
  _StudentAuthState createState() => _StudentAuthState();
}

class _StudentAuthState extends State<StudentAuth> {
  bool processing = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool validUser = false;
  late StudentAdmissionRecord record;
  TextEditingController mobileNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isStudentAlreadyRegistred();
  }

  isStudentAlreadyRegistred() async {
    DocumentSnapshot ds = await firestore
        .collection('imsStudentUsers')
        .doc(widget._currentUser!.email.toString())
        .get();

    if (ds.exists) {
      print('user found !!');
      await firestore
          .collection('admission')
          .doc((ds as dynamic)['admissionref'])
          .get()
          .then((data) => {
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
                    status: (data as dynamic)['status'])
              });
    } else {
      print('finding user from database');
      findStudentDataByEmail();
    }
  }

  firstTimeStudentEntry() async {
    print('_________ trying insert___________');
    FirebaseFirestore.instance
        .collection('imsStudentUsers')
        .doc(widget._currentUser!.email.toString())
        .set({
      'admissionref': record.reference.id,
    });
    print('_________sucees insert___________');
    Get.back();

    setState(() {
      processing = false;
    });
  }

  findStudentDataByEmail() async {
    setState(() {
      processing = true;
    });
    print('________________ trying to check user ________________________');
    final QuerySnapshot result = await firestore
        .collection('admission')
        .where('studentMail', isEqualTo: widget._currentUser!.email.toString())
        .get();

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
      print(record.reference);
      print('________________ data success ________________________');
      setState(() {
        validUser = true;
      });
    }

    setState(() {
      processing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: processing == false
          ? !validUser
              ? DelayedDisplay(
                  delay: const Duration(seconds: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                            widget._currentUser!.photoUrl.toString()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            'Hello ' +
                                widget._currentUser!.displayName.toString(),
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          )),
                      Text(widget._currentUser!.email.toString()),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                              ),
                              onPressed: () {
                                widget.handleSignout();
                              },
                              child: const Text('Logout')),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              onPressed: () {},
                              child: const Text('Help')),
                        ],
                      ),
                    ],
                  ))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: validUser
                            ? NetworkImage(record.imageurl.toString())
                            : NetworkImage(
                                widget._currentUser!.photoUrl.toString()),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: Text(
                          'Hello ' + record.name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        )),
                    Container(
                      child: Text(widget._currentUser!.email.toString()),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: TextField(
                        controller: mobileNumberController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(),
                          labelText: 'Registred Mobile Number',
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent,
                            ),
                            onPressed: () {
                              widget.handleSignout();
                            },
                            child: const Text('Logout')),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepOrange,
                            ),
                            onPressed: () {
                              Get.defaultDialog(
                                  title: 'Dont Worry !!',
                                  middleText: "Ask your Trainer",
                                  backgroundColor: Colors.white,
                                  titleStyle:
                                      const TextStyle(color: Colors.black),
                                  middleTextStyle:
                                      const TextStyle(color: Colors.black),
                                  confirm: const Chip(label: Text('ask now')),
                                  cancel: const Chip(label: Text('cancle')),
                                  onCancel: () {
                                    Get.back();
                                  },
                                  onConfirm: () {
                                    launch('https://wa.me/8793100815');
                                  });
                            },
                            child: const Text('Forgot??')),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            onPressed: () {
                              if (record.mobileno ==
                                  mobileNumberController.text) {
                                firstTimeStudentEntry();
                              }
                            },
                            child: const Text('Continue')),
                      ],
                    ),
                  ],
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget guestEntryDesign() {
    return Column(
      children: [
        Container(
          child: CircleAvatar(
            radius: 40,
            backgroundImage: validUser
                ? NetworkImage(record.imageurl.toString())
                : NetworkImage(widget._currentUser!.photoUrl.toString()),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              'Hello ' + record.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            )),
        Container(
          child: Text(widget._currentUser!.email.toString()),
        ),
        const SizedBox(
          height: 40,
        ),
        Container(
          child: const Text('This app is only for chedo students'),
        ),
      ],
    );
  }
}
