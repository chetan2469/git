// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:chedo/data/mcqData.dart';
import 'package:chedo/exam/exam.dart';
import 'package:chedo/questionData/questionViewOfflineSupport.dart';
import 'package:chedo/questionData/updateMcqOfflineSupport.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class McqGlobalDataOfflineSupport extends StatefulWidget {
  final GoogleSignInAccount? _currentUser;
  String subjectName;
  bool isEditor, isGuest;
  McqGlobalDataOfflineSupport(
      this._currentUser, this.subjectName, this.isEditor, this.isGuest,
      {Key? key})
      : super(key: key);

  @override
  _McqGlobalDataOfflineSupportState createState() =>
      _McqGlobalDataOfflineSupportState();
}

class _McqGlobalDataOfflineSupportState
    extends State<McqGlobalDataOfflineSupport> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool processing = false;
  int limit = 1000;
  List<MCQData> examMcqList = [];
  List<MCQData> allMcqList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      allMcqList.clear();
    });
    if (widget.isGuest) {
      setState(() {
        limit = 50;
      });
    }
  }

  Random r = Random();
//  decode(data.docs[index]['question'])
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
                  )),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back)),
                    title: Text(
                      widget.subjectName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      '( Total Questions )',
                      style: TextStyle(fontSize: 10),
                    ),
                    trailing: ElevatedButton(
                        onPressed: () {
                          generateExamMcqList();
                        },
                        child: const Text('take a test')),
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('mcqData')
                        .where("subject", isEqualTo: widget.subjectName)
                        .orderBy('addedDate')
                        .limit(limit)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final data = snapshot.requireData;
                      allMcqList.clear();
                      MCQData mcq;
                      for (var item in data.docs) {
                        mcq = MCQData(
                            subject: item['subject'],
                            question: decode(item['question']),
                            op1: decode(item['option1']),
                            op2: decode(item['option2']),
                            op3: decode(item['option3']),
                            op4: decode(item['option4']),
                            ans: item['ans'],
                            solution: decode(item['solution']),
                            addedBy: item['addedBy'],
                            isVarified: item['verified'],
                            addedDate: item['addedDate'],
                            reference: item.reference);

                        allMcqList.add(mcq);
                      }
                      return GridView.builder(
                        itemCount: data.size,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onLongPress: () {
                              MCQData mcq = MCQData(
                                  subject: data.docs[index]['subject'],
                                  question:
                                      decode(data.docs[index]['question']),
                                  op1: decode(data.docs[index]['option1']),
                                  op2: decode(data.docs[index]['option2']),
                                  op3: decode(data.docs[index]['option3']),
                                  op4: decode(data.docs[index]['option4']),
                                  ans: data.docs[index]['ans'],
                                  solution:
                                      decode(data.docs[index]['solution']),
                                  addedBy: data.docs[index]['addedBy'],
                                  isVarified: data.docs[index]['verified'],
                                  addedDate: data.docs[index]['addedDate'],
                                  reference: data.docs[index].reference);
                              if (widget.isEditor) {
                                Get.to(UpdateMcqOfflineSupport(
                                    mcq, widget._currentUser, true));
                              } else {
                                Get.snackbar('Warning',
                                    'Only authorised students can able to edit');
                              }
                            },
                            onTap: () {
                              MCQData mcq = MCQData(
                                  subject: data.docs[index]['subject'],
                                  question:
                                      decode(data.docs[index]['question']),
                                  op1: decode(data.docs[index]['option1']),
                                  op2: decode(data.docs[index]['option2']),
                                  op3: decode(data.docs[index]['option3']),
                                  op4: decode(data.docs[index]['option4']),
                                  ans: data.docs[index]['ans'],
                                  solution:
                                      decode(data.docs[index]['solution']),
                                  addedBy: data.docs[index]['addedBy'],
                                  isVarified: data.docs[index]['verified'],
                                  addedDate: data.docs[index]['addedDate']
                                      as Timestamp,
                                  reference: data.docs[index].reference);

                              Get.to(QuestionViewOfflineSupport(
                                  loc: index, mcq: mcq));
                            },
                            child: Container(
                              child:
                                  Center(child: Text((index + 1).toString())),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade400)),
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8),
                      );
                    }),
              ),
            ],
          ),
          widget.isGuest
              ? Positioned(
                  bottom: 50,
                  child: Container(
                    width: 200,
                    child: Text(
                      'only Chedo Student can access and practice all questions from this app',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  void generateExamMcqList() {
    setState(() {
      examMcqList.clear();
    });

    if (allMcqList.length > 100) {
      for (int i = 0; i < 20; i++) {
        examMcqList.add(allMcqList[r.nextInt(allMcqList.length)]);
      }
      Get.to(() => Exam(examMcqList, widget._currentUser, widget.subjectName));
    } else {
      Get.snackbar(
          "Alert", "Question set size is not sufficient to take exam...");
    }
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
