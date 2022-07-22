// ignore_for_file: avoid_print, unnecessary_null_comparison, must_be_immutable, non_constant_identifier_names

import 'dart:io';
import 'package:chedo/courseModule/addCourseEntry.dart';
import 'package:chedo/uploadApi/uploadFile.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chedo/data/studentCourseEntry.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AddStudInfo extends StatefulWidget {
  final GoogleSignInAccount? _currentUser;

  const AddStudInfo(this._currentUser, {Key? key}) : super(key: key);
  @override
  _AddStudInfo createState() => _AddStudInfo();
}

class _AddStudInfo extends State<AddStudInfo> {
  TextEditingController namefieldController = TextEditingController();
  TextEditingController addressfieldController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController optionalNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController aadharfieldController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController addCourseController = TextEditingController();
  TextEditingController outStandingAmountController = TextEditingController();

  int outStandingAmount = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool isMobileNumValidate = true,
      isOptionalMobileNumValidate = true,
      isValidEmail = true,
      isAddressValid = true,
      isBatchTimeValid = true,
      isAadharValid = true;
  bool processing = false, status = true, editing = false;
  late DateTime dob = DateTime.now(), addDate = DateTime.now();
  late String thumbnail, studentMail;
  String downurl =
          'https://image.freepik.com/free-vector/learning-concept-illustration_114360-6186.jpg',
      pursuing_course = '';

  bool flag = true;
  List selectedCoursesReferences = []; // for sending student course_entry array
  List<StudentCourseEntry> selectedCourses = [];
  List<String> courseListForDropDown = [];

  Future<String> getCourseNamebyId(String id) async => firestore
          .collection('student_course')
          .doc(id)
          .get()
          .then((DocumentSnapshot ds) {
        String courseName = ds['course_name'];
        return courseName;
      });

  updateCourseList(StudentCourseEntry studentCourseEntry) {
    setState(() {
      selectedCoursesReferences.add(studentCourseEntry.reference.id);
      selectedCourses.add(studentCourseEntry);
      pursuing_course = studentCourseEntry.course_name;
    });
    print("selectedCoursesReferences Courses    :   " +
        selectedCoursesReferences.toString());
    print("selectedCourses     :   " + selectedCourses.toString());

    updateOutStandingAmount();
  }

  setPhotoUrl(String str) async {
    setState(() {
      downurl = str;
    });
    print(downurl);
  }

  updateOutStandingAmount() {
    setState(() {
      outStandingAmount = 0;
    });

    for (var course in selectedCourses) {
      outStandingAmount =
          outStandingAmount + int.parse(course.course_total_fees);
    }
  }

  void insert() async {
    setState(() {
      processing = true;
    });
    await firestore.collection('admission').doc().set({
      'name': namefieldController.text,
      'address': addressfieldController.text,
      'mobileNo': mobileController.text,
      'optNumber': optionalNoController.text,
      'aadharNo': aadharfieldController.text,
      'batchTime': batchController.text,
      'imageUrl': downurl,
      'addedBy': widget._currentUser!.email.toString(),
      'dateOfBirth': dob,
      'addDate': addDate,
      'status': status,
      'pursuing_course': pursuing_course,
      'studentMail': studentMail,
      'courses': selectedCoursesReferences,
      'outStandingAmount': outStandingAmount,
    });

    setState(() {
      processing = false;
    });

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      outStandingAmount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => ViewImage(downurl)));
              },
              child: SizedBox(
                height: 250,
                width: double.infinity,
                child: Container(
                  color: Colors.white,
                  child: Image.network(downurl),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16.0, 250.0, 16.0, 16.0),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.only(top: 16.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            border:
                                Border.all(color: Colors.white, width: 0.1)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 96.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextField(
                                    controller: namefieldController,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white70, width: 1.0),
                                      ),
                                      labelText: 'Name',
                                      filled: true,
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    subtitle: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: selectedCourses != null
                                          ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: selectedCourses.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                    margin:
                                                        const EdgeInsets.all(2),
                                                    child: Chip(
                                                      deleteIconColor:
                                                          Colors.white,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      label: Text(
                                                          selectedCourses[index]
                                                              .course_name
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      16.0)),
                                                      onDeleted: () {
                                                        print(selectedCourses[
                                                                index]
                                                            .course_name);
                                                        setState(() {
                                                          print(selectedCourses[
                                                                      index]
                                                                  .course_name +
                                                              " removed !!");
                                                          //delete from firestore
                                                          removeElementFromFirestore(
                                                              selectedCourses[
                                                                      index]
                                                                  .reference);
                                                          selectedCourses
                                                              .removeAt(index);
                                                          selectedCoursesReferences
                                                              .removeAt(index);
                                                        });
                                                        updateOutStandingAmount();
                                                      },
                                                    ));
                                              })
                                          : Container(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(1960, 1, 1),
                                          maxTime: DateTime.now(),
                                          onChanged: (date) {
                                        print('change $date');
                                      }, onConfirm: (date) {
                                        print('confirm $date');
                                        setState(() {
                                          dob = date;
                                        });
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: const Text("Date of birth",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                        Text(
                                          dob.day.toString() +
                                              ' / ' +
                                              dob.month.toString() +
                                              ' / ' +
                                              dob.year.toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          print('hello');
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddCourseEntry(
                                                          updateCourseList,
                                                          DateTime.now())));
                                        },
                                        child: const Chip(
                                          label: Text(
                                            '+ Course',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime: DateTime(1960, 1, 1),
                                          maxTime: DateTime.now(),
                                          onChanged: (date) {
                                        print('change $date');
                                      }, onConfirm: (date) {
                                        print('confirm $date');
                                        setState(() {
                                          addDate = date;
                                        });
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: const Text("Joined date",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                        Text(
                                          addDate.day.toString() +
                                              ' / ' +
                                              addDate.month.toString() +
                                              ' / ' +
                                              addDate.year.toString(),
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 2,
                        left: 2,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              //  _showDialog(context);
                            });
                          },
                          // image changer
                          child: UploadFile(setPhotoUrl, downurl),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.white, width: 0.1)),
                    child: Column(
                      children: <Widget>[
                        const ListTile(
                          title: Text(
                            "Student Information",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Divider(
                          height: 15,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          subtitle: TextField(
                            onChanged: (s) {
                              if (s.length == 10) {
                                setState(() {
                                  isMobileNumValidate = true;
                                });
                              } else {
                                setState(() {
                                  isMobileNumValidate = false;
                                });
                              }
                            },
                            keyboardType: TextInputType.number,
                            controller: mobileController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              errorText: !isMobileNumValidate
                                  ? 'please insert valid mobile number'
                                  : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              labelText: 'Mobile Number',
                              filled: true,
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          leading: const Icon(
                            Icons.phone,
                            color: Colors.black54,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          subtitle: TextField(
                            onChanged: (s) {
                              if (s.length == 10 || s.isEmpty) {
                                setState(() {
                                  isOptionalMobileNumValidate = true;
                                });
                              } else {
                                setState(() {
                                  isOptionalMobileNumValidate = false;
                                });
                              }
                            },
                            keyboardType: TextInputType.number,
                            controller: optionalNoController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              errorText: !isOptionalMobileNumValidate
                                  ? 'please insert valid mobile number'
                                  : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              labelText: 'Optional Mobile Number',
                              filled: true,
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          leading: const Icon(
                            Icons.phone,
                            color: Colors.black54,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          subtitle: TextField(
                            onChanged: (email) {
                              if (RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(email)) {
                                setState(() {
                                  studentMail = email;
                                  isValidEmail = true;
                                });
                              } else {
                                setState(() {
                                  isValidEmail = false;
                                });
                              }
                            },
                            controller: emailController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              errorText: !isValidEmail
                                  ? 'please insert valid email'
                                  : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              labelText: 'Gmail',
                              filled: true,
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          leading: const Icon(
                            Icons.mail,
                            color: Colors.black54,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          subtitle: TextField(
                            onChanged: (s) {
                              if (s.length > 5) {
                                setState(() {
                                  isAddressValid = true;
                                });
                              } else {
                                setState(() {
                                  isAddressValid = false;
                                });
                              }
                            },
                            controller: addressfieldController,
                            textCapitalization: TextCapitalization.words,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              errorText: !isAddressValid
                                  ? 'please insert valid Address'
                                  : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                              labelText: 'Address',
                              filled: true,
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          leading: const Icon(
                            Icons.confirmation_number,
                            color: Colors.black54,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          subtitle: TextField(
                            onChanged: (s) {
                              if (s.length == 12) {
                                setState(() {
                                  isAadharValid = true;
                                });
                              } else {
                                setState(() {
                                  isAadharValid = false;
                                });
                              }
                            },
                            keyboardType: TextInputType.number,
                            controller: aadharfieldController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              errorText: !isAadharValid
                                  ? 'please insert valid AAdhar number'
                                  : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ),
                              labelText: 'Aadhar Number',
                              filled: true,
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          leading: const Icon(
                            Icons.confirmation_number,
                            color: Colors.black54,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          subtitle: TextField(
                            onChanged: (s) {
                              if (s.length > 4) {
                                setState(() {
                                  isBatchTimeValid = true;
                                });
                              } else {
                                setState(() {
                                  isBatchTimeValid = false;
                                });
                              }
                            },
                            controller: batchController,
                            textCapitalization: TextCapitalization.words,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              errorText: !isBatchTimeValid
                                  ? 'please insert valid Batch'
                                  : null,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ),
                              labelText: 'Batch Time',
                              filled: true,
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          leading: const Icon(
                            Icons.person,
                            color: Colors.black54,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          subtitle: TextField(
                            enabled: false,
                            controller: outStandingAmountController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ),
                              labelText: outStandingAmount.toString(),
                              filled: true,
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          leading: const Icon(
                            Icons.monetization_on,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: processing
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : const Icon(
                Icons.done,
                color: Colors.white,
              ),
        onPressed: () {
          setState(() {
            print("name : " + namefieldController.text);
            print("mob1 : " + mobileController.text);
            print("mob2 : " + optionalNoController.text);
            print("addr : " + addressfieldController.text);
            print("aadhar : " + aadharfieldController.text);
            print("batch: " + batchController.text);
            if (validate()) {
              insert();
            } else {
              Get.snackbar("Warning !!", "Please Fill all details...");
            }
          });
        },
      ),
    );
  }

  bool validate() {
    if (downurl.length > 10 &&
        pursuing_course.isNotEmpty &&
        emailController.text.length > 15 &&
        namefieldController.text.length > 6 &&
        mobileController.text.length == 10 &&
        optionalNoController.text.length == 10 &&
        addressfieldController.text.length > 5 &&
        aadharfieldController.text.length == 12 &&
        batchController.text.length > 6) {
      return true;
    } else {
      return false;
    }
  }

  void removeElementFromFirestore(DocumentReference<Object?> reference) {
    firestore
        .collection('student_course')
        .doc(reference.id)
        .delete()
        .catchError((onError) {
      print(onError);
    });
  }

// String getCourseNamebyDocumentID(String id) {
//   Firestore.instance
//       .collection('student_course')
//       .document(id)
//       .get()
//       .then((DocumentSnapshot document) {
//     return document['course_name'];
//   });
// }
}

// date picker ====================================================================

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    required Key key,
    required this.child,
    required this.labelText,
    required this.valueText,
    required this.valueStyle,
    required this.onPressed,
  }) : super(key: key);
  final String labelText;
  final String valueText;

  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class PNetworkImage extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final double width, height;

  const PNetworkImage(this.image,
      {required Key key,
      required this.fit,
      required this.height,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error)),
      fit: fit,
      width: width,
      height: height,
    );
  }
}
