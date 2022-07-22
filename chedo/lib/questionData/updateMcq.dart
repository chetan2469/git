// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, avoid_print

import 'package:chedo/data/course_record.dart';
import 'package:chedo/data/mcqData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UpdateMcq extends StatefulWidget {
  MCQData mcq;
  final GoogleSignInAccount? _currentUser;
  UpdateMcq(this.mcq, this._currentUser, {Key? key}) : super(key: key);
  @override
  _AddEnquiryPageState createState() => _AddEnquiryPageState();
}

class _AddEnquiryPageState extends State<UpdateMcq> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> cList = [
    "C Programming",
    "C++ Programming",
    "Data Structure",
    "Python",
    "Java",
    "CS-11",
    "CS-12"
  ];
  List<CourseRecord> courseList = [];
  bool processing = false;
  DateTime selectedDate = DateTime.now();
  DateTime prefTime = DateTime.now();
  int efoListselectedLoc = 0, courseListselectedLoc = 0;
  var grp;
  bool op1R = false, op2R = false, op3R = false, op4R = false;
  int ans = 0;

  TextEditingController question = TextEditingController();
  TextEditingController op1 = TextEditingController();
  TextEditingController op2 = TextEditingController();
  TextEditingController op3 = TextEditingController();
  TextEditingController op4 = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    super.initState();
    question.text = decode(widget.mcq.question);
    op1.text = decode(widget.mcq.op1);
    op2.text = decode(widget.mcq.op2);
    op3.text = decode(widget.mcq.op3);
    op4.text = decode(widget.mcq.op4);
    description.text = decode(widget.mcq.solution);
    grp = widget.mcq.ans;
  }

  final maxlines = 7;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: processing
              ? const CircularProgressIndicator()
              : const Icon(
                  Icons.done,
                ),
          onPressed: () {
            if (isValidate()) {
              print('valid');
              insert();
            } else {
              Get.snackbar(
                "Alert",
                "please fill all details ",
                icon: const Icon(Icons.person, color: Colors.white),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                borderRadius: 20,
                margin: const EdgeInsets.all(15),
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
                isDismissible: true,
                forwardAnimationCurve: Curves.easeOutBack,
              );
            }
          },
        ),
        body: processing
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  ListTile(
                    leading: InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back)),
                    title: const Text(
                      'Update Question',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Container(
                      child: courseListselectedLocDrop(),
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: ListView(
                      children: [
                        // Container(
                        //     height: 55,
                        //     margin: EdgeInsets.only(
                        //         left: 20, right: 20, top: 10, bottom: 10),
                        //     decoration: BoxDecoration(
                        //       color: Colors.grey.shade200,
                        //       borderRadius: BorderRadius.circular(15.0),
                        //     ),
                        //     child: ListTile(
                        //         leading: Icon(Icons.bolt_outlined),
                        //         title: courseListselectedLocDrop())),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: TextField(
                              style: const TextStyle(color: Colors.green),
                              maxLines: 12,
                              controller: question,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                hintText: 'Write Question Here...',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.only(bottom: 200),
                                  child: Icon(
                                    Icons.note,
                                    color: Colors.blue,
                                  ),
                                ),
                                hintStyle: const TextStyle(
                                    color: Colors.blue, fontSize: 12),
                                filled: true,
                                fillColor: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Radio(
                            value: 1,
                            groupValue: grp,
                            onChanged: (value) {
                              setState(() {
                                grp = value;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                          title: TextField(
                            controller: op1,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                              ),
                              hintText: 'option 1...',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              prefixIcon: const Icon(
                                Icons.arrow_right,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Radio(
                            value: 2,
                            groupValue: grp,
                            activeColor: Colors.blue,
                            onChanged: (value) {
                              setState(() {
                                grp = value;
                              });
                            },
                          ),
                          title: TextField(
                            controller: op2,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                              ),
                              hintText: 'option 2...',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              prefixIcon: const Icon(
                                Icons.arrow_right,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Radio(
                            value: 3,
                            onChanged: (value) {
                              setState(() {
                                grp = value;
                              });
                              print(grp);
                            },
                            groupValue: grp,
                          ),
                          title: TextField(
                            controller: op3,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                              ),
                              hintText: 'option 3...',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              prefixIcon: const Icon(
                                Icons.arrow_right,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Radio(
                            value: 4,
                            onChanged: (value) {
                              setState(() {
                                grp = value;
                              });
                            },
                            groupValue: grp,
                          ),
                          title: TextField(
                            controller: op4,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                              ),
                              hintText: 'option 4...',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              prefixIcon: const Icon(
                                Icons.arrow_right,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: TextField(
                            maxLines: 4,
                            controller: description,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                              ),
                              hintText: 'Solution',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              prefixIcon: const Icon(
                                Icons.note,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget courseListselectedLocDrop() {
    return DropdownButton(
        dropdownColor: Colors.white,
        iconEnabledColor: Colors.green,
        style: const TextStyle(color: Colors.black, fontSize: 12),
        value: cList[courseListselectedLoc],
        items: cList.map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Row(
              children: <Widget>[Text(value)],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            setState(() {
              courseListselectedLoc = cList.indexOf(value.toString());

              // box.put('courseListselectedLoc', courseListselectedLoc);
            });
            print(value);
          });
          //getTravelCity(value.name);
        });
  }

  void insert() async {
    setState(() {
      processing = true;
    });

    await firestore
        .collection('mcqData')
        .doc(widget.mcq.reference.id.toString())
        .update({
      'subject': cList[courseListselectedLoc],
      'question': encode(question.text),
      'option1': encode(op1.text),
      'option2': encode(op2.text),
      'option3': encode(op3.text),
      'option4': encode(op4.text),
      'solution': encode(description.text),
      'ans': grp,
      'addedBy': widget._currentUser?.email.toString(),
      'verified': false,
      'addedDate': widget.mcq.addedDate
    });
    setState(() {
      processing = false;
    });

    Navigator.pop(context);
  }

  bool isValidate() {
    if (question.text.toString().length > 5 &&
        op1.text.toString().isNotEmpty &&
        op2.text.toString().isNotEmpty &&
        op3.text.toString().isNotEmpty &&
        op4.text.toString().isNotEmpty &&
        grp != null) {
      return true;
    } else {
      return false;
    }
  }

  String encode(String value) {
    return value.codeUnits
        .map((v) => v.toRadixString(2).padLeft(8, '0'))
        .join(" ");
  }

  String decode(String value) {
    if (value.isNotEmpty) {
      return String.fromCharCodes(
          value.split(" ").map((v) => int.parse(v, radix: 2)));
    } else {
      return 'no more data found...';
    }
  }
}
