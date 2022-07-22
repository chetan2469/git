// ignore_for_file: avoid_print

import 'dart:async';
import 'package:chedo/data/studentAdmissionRecord.dart';
import 'package:chedo/student_module/studentShowDetails.dart';
import 'package:chedo/usersModel/UserDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUsersList extends StatefulWidget {
  const AppUsersList({Key? key}) : super(key: key);

  @override
  _AppUsersListState createState() => _AppUsersListState();
}

class _AppUsersListState extends State<AppUsersList> {
  List<String> userListRef = [];
  List<StudentAdmissionRecord> userList = [];

  bool processing = true;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String placeholder =
      'https://image.freepik.com/free-vector/learning-concept-illustration_114360-6186.jpg';

  @override
  void initState() {
    fetchUsersRefrenceData();
    //  fetchAppUsersData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: const Color.fromARGB(192, 106, 99, 245),
        //   child: const Icon(
        //     Icons.lens,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {
        //     print(userListRef.length);
        //     print(userList.length);
        //   },
        // ),
        appBar: AppBar(
          title: Text('App Users'),
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
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (BuildContext cotext, int i) {
                      return InkWell(
                        onTap: () {
                          print(userList[i].reference.id);
                          Get.to(UserDetails(userList[i]));
                        },
                        child: Container(
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
                                    userList[i].imageurl),
                              ),
                              title: Text(
                                userList[i].name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              trailing: Icon(
                                Icons.verified_user,
                                color: userList[i].isEditor
                                    ? Colors.green
                                    : Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ));
  }

  void _onRefresh() async {
    print("____________________onRefreshing______________________");

    await Future.delayed(const Duration(milliseconds: 1000));

    await fetchUsersRefrenceData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    print("____________________onLoading______________________");
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  fetchUsersRefrenceData() async {
    setState(() {
      processing = false;
      userListRef.clear();
    });
    bool isEditor = false;
    final QuerySnapshot result =
        await firestore.collection('imsStudentUsers').get();

    final List<DocumentSnapshot> documents = result.docs;
    print('________________ trying to get data ________________________');
    for (var data in documents) {
      try {
        setState(() {
          userListRef.add((data as dynamic)['admissionref']);
          isEditor = (data as dynamic)['isEditor'];
        });
      } catch (e) {
        setState(() {
          isEditor = false;
        });
      }

      var snap = await firestore
          .collection('admission')
          .doc((data as dynamic)['admissionref'])
          .get();

      StudentAdmissionRecord record = StudentAdmissionRecord(
        aadharno: (snap as dynamic)['aadharNo'],
        addDate: (snap as dynamic)['addDate'],
        address: (snap as dynamic)['address'],
        batchtime: (snap as dynamic)['batchTime'],
        courses: (snap as dynamic)['courses'],
        dateofbirth: (snap as dynamic)['dateOfBirth'],
        imageurl: (snap as dynamic)['imageUrl'],
        mobileno: (snap as dynamic)['mobileNo'],
        name: (snap as dynamic)['name'],
        optionalno: (snap as dynamic)['optNumber'],
        outStandingAmount: (snap as dynamic)['outStandingAmount'],
        pursuing_course: (snap as dynamic)['pursuing_course'],
        status: (snap as dynamic)['status'],
        reference: snap.reference,
      );
      setState(() {
        record.studentMail = (snap as dynamic)['studentMail'];
        record.isEditor = isEditor;
      });
      userList.add(record);
    }
    print('________________ data success ________________________');
  }
}
