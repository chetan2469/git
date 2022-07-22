// ignore_for_file: avoid_print, await_only_futures

import 'dart:math';

import 'package:chedo/data/mcqData.dart';
import 'package:chedo/exam/exam.dart';
import 'package:chedo/exam/getExam.dart';
import 'package:chedo/questionData/questionView.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: must_be_immutable
class McqGlobalData extends StatefulWidget {
  final GoogleSignInAccount? _currentUser;
  String subjectName;
  bool isAuthorized;
  McqGlobalData(this._currentUser, this.subjectName, this.isAuthorized,
      {Key? key})
      : super(key: key);
  @override
  _McqGlobalDataState createState() => _McqGlobalDataState();
}

class _McqGlobalDataState extends State<McqGlobalData> {
  List<MCQData> mcqDataList = [];
  List<MCQData> filteredMcqDataList = [];
  bool processing = true, ansView = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String searchStr = "";
  String searchBy = 'Name';
  Icon actionIcon = const Icon(Icons.search);
  Widget appBarTitle = const Text("Student List");
  String courseChar = 'C';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool exapanded = false;

  @override
  void initState() {
    _onRefresh();
    super.initState();
  }

  String decode(String value) {
    if (value.isNotEmpty) {
      return String.fromCharCodes(
          value.split(" ").map((v) => int.parse(v, radix: 2)));
    } else {
      return 'no more data found...';
    }
  }

  void viewQuestion(int i) {
    Get.defaultDialog(
      title: 'Question',
      contentPadding: const EdgeInsets.all(10),
      content: Column(
        children: [
          Container(
            color: Colors.blueGrey[50],
            child: ListTile(
              title: Text(decode(filteredMcqDataList[i].question),
                  style: const TextStyle(fontSize: 14)),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20),
            title: Text(
              decode(filteredMcqDataList[i].op1),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20),
            title: Text(decode(filteredMcqDataList[i].op2),
                style: const TextStyle(fontSize: 12)),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20),
            title: Text(decode(filteredMcqDataList[i].op3),
                style: const TextStyle(fontSize: 12)),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(left: 20),
            title: Text(decode(filteredMcqDataList[i].op4),
                style: const TextStyle(fontSize: 12)),
          ),
          ListTile(
              trailing: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.cancel)),
              title: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.greenAccent.shade200,
                ),
                child: Text(
                    "ans : " +
                        filteredMcqDataList[i].ans.toString() +
                        "\n" +
                        decode(filteredMcqDataList[i].solution),
                    style: const TextStyle(fontSize: 12)),
              )),
        ],
      ),
      barrierDismissible: false,
      radius: 10.0,
    );
  }

  Widget confirmBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: const Text("Close"));
  }

  Widget cancelBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: const Text("Edit"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   child: Icon(
          //     Icons.add,
          //     color: Colors.white,
          //   ),
          //   onPressed: () {
          //     Get.to(AddMcq(widget._currentUser));
          //     // Navigator.push(context,
          //     //     MaterialPageRoute(builder: (context) => AddStudInfo()));
          //   },
          // ),
          resizeToAvoidBottomInset: true,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: Container(
            margin: const EdgeInsets.all(2),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                      bottom:
                          BorderSide(width: 1.0, color: Colors.grey.shade300),
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
                      trailing: InkWell(
                        onTap: () {
                          Get.to(() => GetExam(
                              widget._currentUser, filteredMcqDataList));

                          if (filteredMcqDataList.length > 400) {
                            setState(() {
                              processing = true;
                            });

                            Random r = Random();
                            List<MCQData> textMcq = [];

                            for (var i = 0; i < 20; i++) {
                              textMcq.add(filteredMcqDataList[r.nextInt(514)]);
                            }
                            Get.to(() => Exam(textMcq, widget._currentUser,
                                widget.subjectName));
                            setState(() {
                              processing = false;
                            });
                          }
                        },
                        child: const Chip(
                          label: Text(
                            'Start Exam',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: processing
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          color: Colors.grey[100],
                          child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: const WaterDropHeader(),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                            child: GridView.builder(
                              itemCount: filteredMcqDataList.length,
                              itemBuilder: (BuildContext cotext, int i) {
                                return InkWell(
                                  onLongPress: () {
                                    if (widget.isAuthorized) {
                                      deleteDialogue(i);
                                    }
                                  },
                                  onTap: () {
                                    Get.to(QuestionView(filteredMcqDataList, i,
                                        widget.subjectName));
                                  },
                                  child: Container(
                                    child:
                                        Center(child: Text((i + 1).toString())),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey.shade400)),
                                  ),
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 8),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          )),
    );
  }

  void _onRefresh() async {
    print("____________________onRefreshing______________________");
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    await fetchMCQs();
    _refreshController.refreshCompleted();

    // demoListEntry();
    // for change some datatypes of data....
  }

  void _onLoading() async {
    print("____________________onLoading______________________");
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //await fetchMCQs();
    _refreshController.loadComplete();
  }

  fetchMCQs() async {
    setState(() {
      processing = true;
      filteredMcqDataList.clear();
      mcqDataList.clear();
    });
    final QuerySnapshot result = await firestore
        .collection('mcqData')
        .where("subject", isEqualTo: widget.subjectName)
        //  .orderBy('addedDate')\
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    print('________________ trying to get data ________________________');
    for (var data in documents) {
      MCQData record = MCQData(
        addedBy: (data as dynamic)['addedBy'],
        ans: (data as dynamic)['ans'],
        addedDate: (data as dynamic)['addedDate'],
        isVarified: (data as dynamic)['verified'],
        op1: ((data as dynamic)['option1']),
        op2: (data as dynamic)['option2'],
        op3: (data as dynamic)['option3'],
        op4: (data as dynamic)['option4'],
        question: (data as dynamic)['question'],
        solution: (data as dynamic)['solution'],
        subject: (data as dynamic)['subject'],
        reference: data.reference,
      );

      //  record.receipts = (data as dynamic)['receipts'];

      filteredMcqDataList.add(record);
      mcqDataList.add(record);
    }
    print('________________ data success ________________________');
    filteredMcqDataList.sort((a, b) => a.addedDate.compareTo(b.addedDate));
    setState(() {
      processing = false;
    });
  }

  void deleteDialogue(index) {
    Get.defaultDialog(
      title: "Warning !!",
      middleText: 'Really Want to delete this MCQ ??',
      titleStyle: const TextStyle(color: Colors.red),
      middleTextStyle: const TextStyle(color: Colors.blueGrey),
      textConfirm: "Confirm",
      textCancel: "Cancel",
      buttonColor: Colors.redAccent,
      cancelTextColor: Colors.green,
      confirmTextColor: Colors.white,
      barrierDismissible: false,
      radius: 10,
      onConfirm: () {
        deleteMcq(index);
        Get.back();
      },
    );
  }

  deleteMcq(i) async {
    var ref = await filteredMcqDataList[i].reference.id.toString();

    FirebaseFirestore.instance.collection('mcqData').doc(ref).get().then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    setState(() {
      filteredMcqDataList.remove(i);
    });
  }
}
