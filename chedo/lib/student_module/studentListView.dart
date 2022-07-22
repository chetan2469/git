// ignore_for_file: avoid_print

import 'dart:async';
import 'package:chedo/data/studentAdmissionRecord.dart';
import 'package:chedo/student_module/studentShowDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentListView extends StatefulWidget {
  const StudentListView({Key? key}) : super(key: key);

  @override
  _StudentListViewState createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  List<StudentAdmissionRecord> studentList = [];
  List<StudentAdmissionRecord> filteredStudentList = [];
  bool processing = true;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String searchStr = "";
  String searchBy = 'Name';
  Icon actionIcon = const Icon(Icons.search);
  Widget appBarTitle = const Text("Student List");
  String courseChar = 'C';
  static const searchByItems = <String>[
    'Name',
    'Course',
    'Status',
    'Batch Time',
    'Admission',
  ];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String placeholder =
      'https://image.freepik.com/free-vector/learning-concept-illustration_114360-6186.jpg';

  // void demoListEntry() async {
  //   List selectedStudentReceiptReferences = List();

  //   for (var item in studentList) {
  //     DocumentReference referenceId =
  //         Firestore.instance.collection('receipts').document();
  //     await referenceId.setData({
  //       'course_name': item.pursuing_course,
  //       'paying_amount': 0,
  //       'course_id': item.courses.last,
  //       'receipt_date': DateTime(2019),
  //       'next_installment_date': null,
  //       'payment_method': 'Cash',
  //       'receipt_page_number': '000',
  //       'student_id': item.reference.documentID.toString(),
  //       'note': 'default',
  //     });

  //     selectedStudentReceiptReferences.clear();
  //     selectedStudentReceiptReferences.add(referenceId.documentID.toString());

  //     await Firestore.instance
  //         .collection('admission')
  //         .document(item.reference.documentID)
  //         .setData({
  //       'name': item.name,
  //       'address': item.address,
  //       'mobileNo': item.mobileno,
  //       'optNumber': item.optionalno,
  //       'aadharNo': item.aadharno,
  //       'batchTime': item.batchtime,
  //       'imageUrl': item.imageurl,
  //       'dateOfBirth': item.dateofbirth,
  //       'addDate': item.addDate,
  //       'status': item.status,
  //       'courses': item.courses,
  //       'pursuing_course': item.pursuing_course,
  //       'receipts': selectedStudentReceiptReferences,
  //       'outStandingAmount': 0,
  //       'addedBy': 'chetan2469@gmail.com'
  //     });
  //   }
  // }

  sortBy(str) {
    if (str == 'Name') {
      setState(() {
        filteredStudentList.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
      });
    } else if (str == 'Admission') {
      setState(() {
        filteredStudentList.sort((a, b) {
          return a.addDate
              .toString()
              .toLowerCase()
              .compareTo(b.addDate.toString().toLowerCase());
        });
      });
    } else if (str == 'Course') {
      setState(() {
        filteredStudentList.sort((a, b) {
          return a.pursuing_course
              .toLowerCase()
              .compareTo(b.pursuing_course.toLowerCase());
        });
      });
    } else if (str == 'Status') {
      setState(() {
        filteredStudentList.sort((a, b) {
          return a.status
              .toString()
              .toLowerCase()
              .compareTo(b.status.toString().toLowerCase());
        });
      });
    } else if (str == 'Batch Time') {
      filteredStudentList.sort((a, b) {
        return a.batchtime.toLowerCase().compareTo(b.batchtime.toLowerCase());
      });
    }
  }

  final List<DropdownMenuItem<String>> _dropDownMenuItems = searchByItems
      .map(
        (String value) => DropdownMenuItem<String>(
          value: value,
          child: InkWell(
              onTap: () {
                print(value);
              },
              child: Text(value)),
        ),
      )
      .toList();

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  searchByAction(str) {
    if (str == 'Name') {
      filteredStudentList.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else if (str == 'Course') {
      print('sorting by course');
      filteredStudentList.sort((a, b) {
        return a.pursuing_course
            .toLowerCase()
            .compareTo(b.pursuing_course.toLowerCase());
      });
    }
  }

  // void _sendSMS(String message, List<String> recipents) async {
  //   String _result = await sendSMS(message: message, recipients: recipents)
  //       .catchError((onError) {
  //     print(onError);
  //   });
  //    print(_result);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(192, 106, 99, 245),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => AddStudInfo()));
          },
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(192, 106, 99, 245),
          title: appBarTitle,
          actions: [
            DropdownButton(
              items: searchByItems.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (s) {
                sortBy(s);
                print(s);
              },
            )
          ],
        ),
        resizeToAvoidBottomInset: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        body: processing
            ? const Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.grey[100],
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: const WaterDropHeader(),
                  // footer: CustomFooter(
                  //   builder: (BuildContext context, LoadStatus mode) {
                  //     Widget body;
                  //     if (mode == LoadStatus.idle) {
                  //       body = Text("no more data");
                  //     } else if (mode == LoadStatus.loading) {
                  //       body = CircularProgressIndicator();
                  //     } else if (mode == LoadStatus.failed) {
                  //       body = Text("Load Failed!Click retry!");
                  //     } else if (mode == LoadStatus.canLoading) {
                  //       body = Text("release to load more");
                  //     } else {
                  //       body = Text("No more Data");
                  //     }
                  //     return Container(
                  //       height: 55.0,
                  //       child: Center(child: body),
                  //     );
                  //   },
                  // ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView.builder(
                    itemCount: filteredStudentList.length,
                    itemBuilder: (BuildContext cotext, int i) {
                      return Container(
                        height: 80,
                        padding: const EdgeInsets.only(top: 5),
                        margin: const EdgeInsets.only(
                            top: 5, bottom: 1, left: 5, right: 5),
                        //color: Colors.grey[200],
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1, color: Colors.black12),
                          color: Colors.white.withOpacity(0.2),
                        ),
                        //color: Colors.grey[200],,
                        child: SizedBox(
                          height: 80,
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(placeholder),
                                foregroundImage: CachedNetworkImageProvider(
                                    filteredStudentList[i].imageurl),
                              ),
                              title: Text(
                                filteredStudentList[i].name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Row(
                                children: <Widget>[
                                  ActionChip(
                                      avatar: CircleAvatar(
                                        backgroundColor: getColor(
                                            filteredStudentList[i]
                                                .pursuing_course[0]),
                                        child: Text(filteredStudentList[i]
                                            .pursuing_course[0]),
                                      ),
                                      label: Text(filteredStudentList[i]
                                          .pursuing_course),
                                      onPressed: () {}),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launch("sms://" +
                                          filteredStudentList[i].mobileno);
                                    },
                                    child: const CircleAvatar(
                                      radius: 16,
                                      child: Icon(
                                        Icons.message,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launch("tel://" +
                                          filteredStudentList[i].mobileno);
                                    },
                                    child: const CircleAvatar(
                                      radius: 16,
                                      child: Icon(
                                        Icons.phone,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StudentShowDetails(
                                                  filteredStudentList[i])));
                                });
                                print(filteredStudentList[i]);
                              },
                              trailing: Icon(
                                Icons.donut_small,
                                size: 16,
                                color: filteredStudentList[i].status
                                    ? Colors.green
                                    : Colors.red,
                              )),
                        ),
                      );
                    },
                  ),
                ),
              ));
  }

  void _onRefresh() async {
    print("____________________onRefreshing______________________");
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    await fetchStudentData();
    _refreshController.refreshCompleted();

    // demoListEntry();
    // for change some datatypes of data....
  }

  void _onLoading() async {
    print("____________________onLoading______________________");
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //await fetchStudentData();
    _refreshController.loadComplete();
  }

  fetchStudentData() async {
    setState(() {
      processing = true;
      filteredStudentList.clear();
      studentList.clear();
    });
    final QuerySnapshot result = await firestore.collection('admission').get();

    final List<DocumentSnapshot> documents = result.docs;
    print('________________ trying to get data ________________________');
    for (var data in documents) {
      StudentAdmissionRecord record = StudentAdmissionRecord(
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

          //  receipts: (data as dynamic)['receipts'],
          status: (data as dynamic)['status']);

      //  record.receipts = (data as dynamic)['receipts'];

      studentList.add(record);
      filteredStudentList.add(record);
    }
    print('________________ data success ________________________');

    setState(() {
      processing = false;
    });

    filteredStudentList.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  Color getColor(String char) {
    switch (char) {
      case 'C':
        return Colors.red;
      case 'P':
        return Colors.yellow;
      case 'J':
        return Colors.brown;
      case 'F':
        return Colors.blue;
      case 'D':
        return Colors.grey;
      case 'W':
        return Colors.white;
      default:
        return Colors.green;
    }
  }
}
