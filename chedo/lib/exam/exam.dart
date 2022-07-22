// ignore_for_file: no_logic_in_create_state

import 'package:chedo/data/mcqData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'examResultDetails.dart';

// ignore: must_be_immutable
class Exam extends StatefulWidget {
  List<MCQData> selectedMcqForExam;
  final GoogleSignInAccount? _currentUser;
  String subjectName;
  Exam(this.selectedMcqForExam, this._currentUser, this.subjectName, {Key? key})
      : super(key: key);

  @override
  _ExamState createState() => _ExamState(selectedMcqForExam);
}

class _ExamState extends State<Exam> {
  List<MCQData> selectedMcqForExam;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool submitEnabled = false;
  _ExamState(this.selectedMcqForExam);
  int ans = 0, marks = 0;
  List<int> radioAnswers = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];

  @override
  void initState() {
    super.initState();
    // for (var i = 0; i < 20; i++) {
    //   radioAnswers[i] = Random().nextInt(4);
    // }
  }

  void checkSubmitEnabled() {
    setState(() {
      submitEnabled = radioAnswers.contains(0) ? false : true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: selectedMcqForExam.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: getTabs(),
            isScrollable: true,
          ),
          title: Text('Test of ' + widget.subjectName),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (submitEnabled) {
                  calculateMarks();

                  Get.off(() =>
                      ExamResult(selectedMcqForExam, radioAnswers, marks));
                } else {
                  Get.snackbar('Warning !!', 'Please fill all answers',
                      isDismissible: true,
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.black54,
                      colorText: Colors.white);
                }
              },
              child: const Text(
                'Submit',
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      submitEnabled ? Colors.lightGreen : Colors.grey)),
            )
          ],
        ),
        body: TabBarView(children: getTabBarView(context)),
      ),
    );
  }

  List<Widget> getTabs() {
    List<Widget> list = [];
    for (int i = 0; i < selectedMcqForExam.length; i++) {
      list.add(Tab(
          icon: Container(
        width: 32,
        height: 42,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: radioAnswers[i] == 0
                    ? Colors.redAccent.shade100
                    : Colors.greenAccent.shade100)),
        child: Center(
          child: Text(
            (i + 1).toString(),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      )));
    }
    return list;
  }

  List<Widget> getTabBarView(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < selectedMcqForExam.length; i++) {
      list.add(Tab(
          icon: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              color: Colors.blueGrey[50],
              padding: const EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              child: Text(
                selectedMcqForExam[i].question,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
                leading: Radio(
                  value: 1,
                  groupValue: radioAnswers[i],
                  onChanged: (value) {
                    setState(() {
                      radioAnswers[i] = getRadioValue(value);
                      checkSubmitEnabled();
                    });
                  },
                  activeColor: Colors.blue,
                ),
                title: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          radioAnswers[i] = 1;
                          checkSubmitEnabled();
                        });
                      },
                      child: Text(selectedMcqForExam[i].op1,
                          style: const TextStyle(fontSize: 14)),
                    ))),
            ListTile(
                leading: Radio(
                  value: 2,
                  groupValue: radioAnswers[i],
                  onChanged: (value) {
                    setState(() {
                      radioAnswers[i] = getRadioValue(value);
                      checkSubmitEnabled();
                    });
                  },
                  activeColor: Colors.blue,
                ),
                title: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(10)),
                    child: Builder(builder: (context) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            radioAnswers[i] = 2;
                            checkSubmitEnabled();
                          });
                        },
                        child: Text(selectedMcqForExam[i].op2,
                            style: const TextStyle(fontSize: 14)),
                      );
                    }))),
            ListTile(
                leading: Radio(
                  value: 3,
                  groupValue: radioAnswers[i],
                  onChanged: (value) {
                    setState(() {
                      radioAnswers[i] = getRadioValue(value);
                      checkSubmitEnabled();
                    });
                  },
                  activeColor: Colors.blue,
                ),
                title: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          radioAnswers[i] = 3;
                          checkSubmitEnabled();
                        });
                      },
                      child: Text(selectedMcqForExam[i].op3,
                          style: const TextStyle(fontSize: 14)),
                    ))),
            ListTile(
                leading: Radio(
                  value: 4,
                  groupValue: radioAnswers[i],
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        radioAnswers[i] = getRadioValue(value);
                        checkSubmitEnabled();
                      });
                    });
                  },
                  activeColor: Colors.blue,
                ),
                title: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(10)),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          radioAnswers[i] = 4;
                          checkSubmitEnabled();
                        });
                      },
                      child: Text(selectedMcqForExam[i].op4,
                          style: const TextStyle(fontSize: 14)),
                    ))),
          ],
        ),
      )));
    }
    return list;
  }

  int getRadioValue(val) {
    if (val == 1) {
      return 1;
    } else if (val == 2) {
      return 2;
    } else if (val == 3) {
      return 3;
    } else if (val == 4) {
      return 4;
    }
    return 0;
  }

  void calculateMarks() {
    setState(() {
      marks = 0;
    });
    for (int i = 0; i < selectedMcqForExam.length; i++) {
      if (selectedMcqForExam[i].ans == radioAnswers[i]) {
        setState(() {
          marks++;
        });
      }
    }
    putResultonServer();
  }

  putResultonServer() async {
    await firestore
        .collection('imsStudentUsers')
        .doc(widget._currentUser!.email.toString())
        .collection('testResults')
        .doc()
        .set({
      'date': DateTime.now(),
      'marks': marks,
      'totalMarks': radioAnswers.length,
      'subject': widget.subjectName
    });
  }
}
