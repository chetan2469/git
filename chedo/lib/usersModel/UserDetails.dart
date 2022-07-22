// ignore_for_file: avoid_print, unnecessary_null_comparison, use_key_in_widget_constructors

import 'dart:io';
import 'package:chedo/courseModule/addCourseEntry.dart';
import 'package:chedo/data/studentAdmissionRecord.dart';
import 'package:chedo/student_module/studentSubmittedNotes.dart';
import 'package:chedo/uploadApi/uploadFile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chedo/data/receiptEntry.dart';
import 'package:chedo/data/studentCourseEntry.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetails extends StatefulWidget {
  final StudentAdmissionRecord record;

  const UserDetails(this.record, {Key? key}) : super(key: key);

  @override
  _UserDetails createState() => _UserDetails();
}

class _UserDetails extends State<UserDetails> {
  final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];

  TextEditingController namefieldController = TextEditingController();
  TextEditingController addressfieldController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController optionalNoController = TextEditingController();
  TextEditingController aadharfieldController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController addCourseController = TextEditingController();
  TextEditingController outStandingAmountController = TextEditingController();

  bool validator1 = true,
      validator2 = true,
      validator3 = true,
      validator4 = true,
      validator5 = true,
      validator6 = true,
      validator7 = true,
      togg = false;
  late bool processing = false, status, editing = false;
  late DateTime dob, addDate;
  late String thumbnail;
  late String photourl, downurl;
  bool flag = true;
  late int outStandingAmount;
  String studentMail = '';
  List selectedCoursesReferences = [];
  List<StudentCourseEntry> selectedCourses = [];

  List selectedStudentReceiptReferences = [];
  List<ReceiptEntry> studentReceiptList = [];

  TextStyle textstyle = const TextStyle(
    color: Colors.black,
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      processing = true;
      namefieldController.text = widget.record.name;
      addressfieldController.text = widget.record.address;
      mobileController.text = widget.record.mobileno;
      optionalNoController.text = widget.record.optionalno;
      aadharfieldController.text = widget.record.aadharno;
      courseController.text = widget.record.pursuing_course;
      batchController.text = widget.record.batchtime;
      photourl = widget.record.imageurl;
      dob = widget.record.dateofbirth.toDate();
      addDate = widget.record.addDate.toDate();
      status = widget.record.status;
      selectedCoursesReferences = []..addAll(widget.record.courses);
      selectedStudentReceiptReferences = []..addAll(widget.record.receipts);
      outStandingAmount = widget.record.outStandingAmount;
    });

    print(selectedCoursesReferences);
    print(selectedStudentReceiptReferences);

    fetchLists();

    setState(() {
      processing = false;
    });
    isUrerCanLogin();
  }

  isUrerCanLogin() async {
    await FirebaseFirestore.instance
        .collection('admission')
        .doc(widget.record.reference.id)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {
        setState(() {
          studentMail = (ds as dynamic)['studentMail'];
        });
      }
    });
  }

  setPhotoUrl(String str) async {
    setState(() {
      photourl = str;
    });
    FirebaseFirestore.instance
        .collection('admission')
        .doc(widget.record.reference.id)
        .update({
      'imageUrl': photourl,
    });
  }

  void fetchLists() async {
    //fetch receipts and courses list from array refrences
    for (var i = 0; i < selectedCoursesReferences.length; i++) {
      FirebaseFirestore.instance
          .collection('student_course')
          .doc(selectedCoursesReferences[i].toString())
          .get()
          .then((DocumentSnapshot ds) {
        setState(() {
          StudentCourseEntry e = StudentCourseEntry(
              course_name: (ds as dynamic)['course_name'],
              course_fees: (ds as dynamic)['course_fees'],
              course_start_date: (ds as dynamic)['course_start_date'],
              course_total_fees: (ds as dynamic)['course_total_fees'],
              course_validity_date: (ds as dynamic)['course_validity_date'],
              reference: ds.reference);
          print('object');
          selectedCourses.add(e);
        });
      });
    }

    for (var i = 0; i < selectedStudentReceiptReferences.length; i++) {
      FirebaseFirestore.instance
          .collection('receipts')
          .doc(selectedStudentReceiptReferences[i].toString())
          .get()
          .then((DocumentSnapshot ds) {
        setState(() {
          ReceiptEntry e = ReceiptEntry(
              course_id: (ds as dynamic)['course_id'],
              course_name: (ds as dynamic)['course_name'],
              next_installment_date: (ds as dynamic)['next_installment_date'],
              note: (ds as dynamic)['note'],
              paying_amount: (ds as dynamic)['paying_amount'],
              payment_method: (ds as dynamic)['payment_method'],
              receipt_date: (ds as dynamic)['receipt_date'],
              receipt_page_number: (ds as dynamic)['receipt_page_number'],
              reference: (ds as dynamic)['reference'],
              student_id: (ds as dynamic)['student_id']);

          studentReceiptList.add(e);
        });
      });
    }
  }

  deleteCourseChip(int index) {
    setState(() {
      print(selectedCourses[index].course_name + " removed !!");
      FirebaseFirestore.instance
          .collection('student_course')
          .doc(selectedCourses[index].reference.id)
          .delete()
          .catchError((onError) {
        print(onError);
      });
      //delete from firestore

      delCourse(selectedCoursesReferences[index].toString());

      selectedCourses.removeAt(index);
      selectedCoursesReferences.removeAt(index);
    });
  }

  Future<void> chipOptions(int index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => EditStudentCourseEntry(
                //             selectedCoursesReferences[index].toString())));
              },
              child: const ListTile(
                leading: Icon(
                  Icons.info,
                  color: Colors.green,
                ),
                title: Text(
                  'View Info',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                if (selectedCourses.length > 1 &&
                    selectedCoursesReferences.length > 1) {
                  deleteCourseChip(index);
                } else {
                  _showAlert(
                      "Student atleast have one course entry if you want to delete one then you should add anather entry first");
                }
              },
              child: const ListTile(
                leading: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                title: Text(
                  'Delete Course',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _showAlert(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert !!'),
          content: Text(msg),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void update() async {
    await FirebaseFirestore.instance
        .collection('admission')
        .doc(widget.record.reference.id)
        .update({
      'name': namefieldController.text,
      'address': addressfieldController.text,
      'mobileNo': mobileController.text,
      'optNumber': optionalNoController.text,
      'aadharNo': aadharfieldController.text,
      'courseName': courseController.text,
      'batchTime': batchController.text,
      'imageUrl': photourl,
      'dateOfBirth': dob,
      'addDate': addDate,
      'status': status,
      'outStandingAmountController': outStandingAmountController.text,
      'courses': selectedCoursesReferences,
    });
    showDialog(
        context: context,
        builder: (_) => const AlertDialog(
              title: Text("Updated !!"),
              content: Text("Data Updated Successfully..."),
            ));
    print('Update Successfully !!');
  }

  updateReceiptList(ReceiptEntry receiptEntry) {
    setState(() {
      selectedStudentReceiptReferences.add(receiptEntry.reference.id);
      studentReceiptList.add(receiptEntry);

      outStandingAmount = outStandingAmount - receiptEntry.paying_amount;
    });

    print("studentReceiptList     :   " +
        selectedStudentReceiptReferences.toString());

    FirebaseFirestore.instance
        .collection('admission')
        .doc(widget.record.reference.id)
        .update({'receipts': selectedStudentReceiptReferences});

    FirebaseFirestore.instance
        .collection('admission')
        .doc(widget.record.reference.id)
        .update({'outStandingAmount': outStandingAmount});
  }

  updateCourseList(StudentCourseEntry studentCourseEntry) {
    setState(() {
      selectedCoursesReferences.add(studentCourseEntry.reference.id);
      selectedCourses.add(studentCourseEntry);

      outStandingAmount =
          outStandingAmount + int.parse(studentCourseEntry.course_fees);
    });

    print("selectedCourses     :   " + selectedCourses.toString());

    FirebaseFirestore.instance
        .collection('admission')
        .doc(widget.record.reference.id)
        .update({
      'courses': selectedCoursesReferences,
      'pursuing_course': studentCourseEntry.course_name
    });

    FirebaseFirestore.instance
        .collection('admission')
        .doc(widget.record.reference.id)
        .update({'outStandingAmount': outStandingAmount});
  }

  updateOutStandingAmount(int amt) {
    setState(() {
      outStandingAmount = amt;
    });

    for (var course in selectedCourses) {
      setState(() {
        outStandingAmount =
            outStandingAmount + int.parse(course.course_total_fees);
      });
    }
    print(outStandingAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: processing == false
          ? SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ViewImage(photourl)));
                    },
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 280,
                          width: double.infinity,
                          child: PNetworkImage(photourl,
                              fit: BoxFit.cover, height: 280, width: 280),
                        ),
                        Positioned(
                            right: 20,
                            top: 20,
                            child: Switch(
                                value: widget.record.isEditor,
                                onChanged: (v) {
                                  setState(() {
                                    widget.record.isEditor = v;
                                  });
                                  print(widget.record.reference.toString());
                                })),
                        Positioned(
                            bottom: 0,
                            right: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.white),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    Get.to(StudentSubmittedNotes(studentMail));
                                  },
                                  icon: const Icon(
                                    Icons.info,
                                    color: Colors.blueAccent,
                                  )),
                            )),
                      ],
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
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(left: 96.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        editing
                                            ? TextField(
                                                controller: namefieldController,
                                                decoration: InputDecoration(
                                                    hintText:
                                                        widget.record.name),
                                              )
                                            : Text(
                                                widget.record.name,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          subtitle: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.07,
                                            child: selectedCourses != null
                                                ? ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        selectedCourses.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          child: ActionChip(
                                                              avatar:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                child: Text(
                                                                    selectedCourses[
                                                                            index]
                                                                        .course_name
                                                                        .toString()[0],
                                                                    style: textstyle),
                                                              ),
                                                              label: Text(
                                                                  selectedCourses[
                                                                          index]
                                                                      .course_name
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16.0)),
                                                              onPressed: () {
                                                                chipOptions(
                                                                    index);
                                                              }));
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
                                            if (editing) {
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
                                            }
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                  dob.day.toString() +
                                                      ' / ' +
                                                      dob.month.toString() +
                                                      ' / ' +
                                                      dob.year.toString(),
                                                  style: textstyle),
                                              Text("DOB", style: textstyle)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                print(selectedCourses);
                                                Get.to(AddCourseEntry(
                                                  updateCourseList,
                                                  DateTime.now(),
                                                ));
                                              },
                                              child: const Chip(
                                                label: Text(
                                                  '+ Course',
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                                            if (editing) {
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
                                            }
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                  addDate.day.toString() +
                                                      ' / ' +
                                                      addDate.month.toString() +
                                                      ' / ' +
                                                      addDate.year.toString(),
                                                  style: textstyle),
                                              Text("Joined", style: textstyle)
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
                                child: Container(
                                  child: UploadFile(setPhotoUrl, photourl),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text("Student Information",
                                    style: textstyle),
                              ),
                              const Divider(),
                              ListTile(
                                title: Text("Email", style: textstyle),
                                subtitle: editing
                                    ? TextField(
                                        keyboardType: TextInputType.number,
                                        controller: mobileController,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            hintText: widget.record.mobileno),
                                      )
                                    : Text(
                                        widget.record.studentMail,
                                        style: textstyle,
                                      ),
                                leading: InkWell(
                                    onLongPress: () {
                                      Clipboard.setData(ClipboardData(
                                          text: mobileController.text));
                                    },
                                    onTap: () {
                                      if (mobileController.text.length == 10) {
                                        launch(
                                            "tel://" + mobileController.text);
                                      }
                                    },
                                    child: Icon(
                                      Icons.phone,
                                      color: mobileController.text.length == 10
                                          ? Colors.green
                                          : Colors.grey,
                                    )),
                              ),
                              const Divider(),
                              ListTile(
                                title: Text("Phone", style: textstyle),
                                subtitle: editing
                                    ? TextField(
                                        keyboardType: TextInputType.number,
                                        controller: mobileController,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            hintText: widget.record.mobileno),
                                      )
                                    : Text(
                                        widget.record.mobileno,
                                        style: textstyle,
                                      ),
                                leading: InkWell(
                                    onLongPress: () {
                                      Clipboard.setData(ClipboardData(
                                          text: mobileController.text));
                                    },
                                    onTap: () {
                                      if (mobileController.text.length == 10) {
                                        launch(
                                            "tel://" + mobileController.text);
                                      }
                                    },
                                    child: Icon(
                                      Icons.phone,
                                      color: mobileController.text.length == 10
                                          ? Colors.green
                                          : Colors.grey,
                                    )),
                              ),
                              ListTile(
                                title:
                                    Text("Optional Number", style: textstyle),
                                subtitle: editing
                                    ? TextField(
                                        keyboardType: TextInputType.number,
                                        controller: optionalNoController,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            hintText: widget.record.optionalno),
                                      )
                                    : Text(
                                        widget.record.optionalno,
                                        style: textstyle,
                                      ),
                                leading: InkWell(
                                    onTap: () {
                                      if (optionalNoController.text.length ==
                                          10) {
                                        launch("tel://" +
                                            optionalNoController.text);
                                      }
                                    },
                                    child: Icon(
                                      Icons.phone,
                                      color:
                                          optionalNoController.text.length == 10
                                              ? Colors.green
                                              : Colors.grey,
                                    )),
                              ),
                              ListTile(
                                title: Text("Address", style: textstyle),
                                subtitle: editing
                                    ? TextField(
                                        controller: addressfieldController,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            hintText: widget.record.address),
                                      )
                                    : Text(widget.record.address),
                                leading: const Icon(Icons.confirmation_number),
                              ),
                              ListTile(
                                title: Text(
                                  "Aadhar Number",
                                  style: textstyle,
                                ),
                                subtitle: editing
                                    ? TextField(
                                        keyboardType: TextInputType.number,
                                        controller: aadharfieldController,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            hintText: widget.record.aadharno),
                                      )
                                    : Text(widget.record.aadharno,
                                        style: textstyle),
                                leading: const Icon(Icons.confirmation_number),
                              ),
                              ListTile(
                                title: Text(
                                  "Batch Time",
                                  style: textstyle,
                                ),
                                subtitle: editing
                                    ? TextField(
                                        controller: batchController,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            hintText: widget.record.batchtime),
                                      )
                                    : Text(widget.record.batchtime,
                                        style: textstyle),
                                leading: const Icon(Icons.person),
                              ),
                              const Divider(),
                              ListTile(
                                subtitle: TextField(
                                  enabled: false,
                                  controller: outStandingAmountController,
                                  decoration: InputDecoration(
                                      hintText: outStandingAmount.toString()),
                                ),
                                leading: const Icon(Icons.monetization_on),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                  title:
                                      Text("Fees Receipts", style: textstyle),
                                  trailing: InkWell(
                                      onTap: () {
                                        print(studentReceiptList);
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             AddReceipt(
                                        //                 selectedCourses,
                                        //                 DateTime.now(),
                                        //                 widget.record.reference,
                                        //                 outStandingAmount,
                                        //                 updateOutStandingAmount,
                                        //                 updateReceiptList)));
                                      },
                                      child: const Chip(
                                          backgroundColor: Colors.green,
                                          label: Text(
                                            '+ add ',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )))),
                              const Divider(),
                              studentReceiptList != null
                                  ? SizedBox(
                                      height: studentReceiptList.length *
                                              60.toDouble() +
                                          40,
                                      child: receiptsListBuilder(),
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        child: editing ? const Icon(Icons.done) : const Icon(Icons.edit),
        onPressed: () {
          setState(() {
            if (editing) {
              print("name : " + namefieldController.text);
              print("mob1 : " + mobileController.text);
              print("mob2 : " + optionalNoController.text);
              print("addr : " + addressfieldController.text);
              print("aadhar : " + aadharfieldController.text);
              print("batch: " + batchController.text);
              update();
            }
            editing = !editing;
          });
        },
      ),
    );
  }

  Widget receiptsListBuilder() {
    return ListView.builder(
      itemCount: studentReceiptList.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(.1))),
          margin: const EdgeInsets.only(bottom: 5),
          child: ListTile(
            leading:
                studentReceiptList[index].payment_method.toString() == 'Cash'
                    ? const Icon(Icons.monetization_on)
                    : const Icon(Icons.wifi),
            title: Text(studentReceiptList[index].paying_amount.toString()),
            subtitle: studentReceiptList[index].receipt_date != null
                ? Text(
                    studentReceiptList[index].receipt_date.toDate().toString())
                : Text('today', style: textstyle),
            trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           EditReceipt(studentReceiptList[index])))
                }),
          ),
        );
      },
    );
  }

  // course ====================================================================

  void delCourse(String course) async {
    List clone = [];

    setState(() {
      clone.add(course);
    });

    FirebaseFirestore.instance
        .collection('admission')
        .doc(widget.record.reference.id)
        .update({
      'courses': FieldValue.arrayRemove(clone),
    });
  }
}

class PNetworkImage extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final double width, height;

  const PNetworkImage(this.image,
      {required this.fit, required this.height, required this.width});

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
