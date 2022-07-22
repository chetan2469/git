// ignore_for_file: must_be_immutable, avoid_print, await_only_futures

import 'package:chedo/data/mcqData.dart';
import 'package:chedo/questionData/questionView.dart';
import 'package:chedo/questionData/updateMcq.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'addMcq.dart';

class MCQContribution extends StatefulWidget {
  GoogleSignInAccount? _currentUser;
  MCQContribution(this._currentUser, {Key? key}) : super(key: key);
  @override
  _MCQContributionState createState() => _MCQContributionState();
}

class _MCQContributionState extends State<MCQContribution> {
  List<MCQData> mcqDataList = [];
  List<MCQData> filteredMcqDataList = [];
  bool processing = true, ansView = false, editMode = false;
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

  void updatefilteredMcqDataList(int i, MCQData data) {
    setState(() {
      filteredMcqDataList[i] = data;
    });
  }

  String decode(String value) {
    return String.fromCharCodes(
        value.split(" ").map((v) => int.parse(v, radix: 2)));
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Get.to(AddMcq(widget._currentUser, filteredMcqDataList));
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => AddStudInfo()));
            },
          ),
          resizeToAvoidBottomInset: true,
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: processing
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  margin: const EdgeInsets.all(2),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: InkWell(
                              onTap: () => Get.back(),
                              child: const Icon(Icons.arrow_back)),
                          title: const Text(
                            'My Question Contributuin',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: filteredMcqDataList.isEmpty
                            ? const Center(
                                child: Text(
                                  "no question till added but you can add yourself...",
                                  style: TextStyle(color: Colors.black),
                                ),
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
                                        onDoubleTap: () {
                                          Get.to(UpdateMcq(
                                            filteredMcqDataList[i],
                                            widget._currentUser,
                                          ));
                                        },
                                        onLongPress: () {
                                          //  viewQuestion(i);
                                          deleteDialogue(i);
                                          // print(filteredMcqDataList[i]
                                          //     .reference
                                          //     .id
                                          //     .toString());
                                        },
                                        onTap: () {
                                          Get.to(QuestionView(
                                              filteredMcqDataList,
                                              i,
                                              filteredMcqDataList[i].subject));
                                        },
                                        child: Container(
                                          child: Center(
                                              child: Text((i + 1).toString())),
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: getBorderColor(
                                                      filteredMcqDataList[i]
                                                          .subject))),
                                        ),
                                      );
                                    },
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 6),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                )),
    );
  }

  Color getBorderColor(String course) {
    switch (course) {
      case "C Programming":
        return Colors.blue.shade200;
      case "C++ Programming":
        return Colors.blue.shade400;
      case "Java":
        return Colors.red.shade400;
      case "Python":
        return Colors.yellow.shade400;
    }
    return Colors.grey.shade400;
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
        .where('addedBy', isEqualTo: widget._currentUser!.email.toString())
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

      print(record.op1);
      filteredMcqDataList.add(record);
      mcqDataList.add(record);
    }
    print('________________ data success ________________________');
    filteredMcqDataList.sort((a, b) => a.addedDate.compareTo(b.addedDate));
    setState(() {
      processing = false;
    });
  }

  String stringShowLimit(String str) {
    if (str.length < 50) {
      return str;
    } else if (str.contains('\n')) {
      return str.substring(0, str.indexOf('\n'));
    } else {
      return str.substring(0, 50);
    }
  }

  String fromSecondLine(String str) {
    if (str.contains('\n')) {
      return str.substring(str.indexOf('\n') + 1, str.length);
    } else {
      return '';
    }
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
