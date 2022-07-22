import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chedo/course_module/addCourse.dart';
import 'package:chedo/data/course_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'courseDetails.dart';

// ignore: must_be_immutable
class CourseListView extends StatefulWidget {
  final GoogleSignInAccount? _currentUser;
  const CourseListView(this._currentUser, {Key? key}) : super(key: key);
  @override
  _CourseListViewState createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  List<CourseRecord> courseList = [];
  List<CourseRecord> filteredcourseList = [];
  bool processing = true;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  String searchStr = "";
  String searchBy = 'Name';
  Icon actionIcon = const Icon(Icons.search);
  Widget appBarTitle = const Text("");

  @override
  void initState() {
    super.initState();
    fetchCourseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(AddCourse(widget._currentUser));
          }),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Course List'),
      ),
      body: Center(
        child: processing
            ? const CircularProgressIndicator()
            : SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: const WaterDropHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.builder(
                  itemCount: filteredcourseList.length,
                  itemBuilder: (BuildContext cotext, int i) {
                    return Padding(
                      key: ValueKey(filteredcourseList[i].name),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: InkWell(
                        onLongPress: () {
                          Get.defaultDialog(
                              content: Text('Are You Sure want to delete ' +
                                  filteredcourseList[i].name +
                                  " course"),
                              onConfirm: () {
                                deleteCourse(
                                    filteredcourseList[i].reference.id);
                                setState(() {
                                  filteredcourseList.remove(i);
                                });
                              },
                              cancel: const Text('Cancle'),
                              confirm: const Text('delete'));
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CourseDetails(filteredcourseList[i])));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 3, left: 10, right: 10),
                          //color: Colors.grey[200],
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1, color: Colors.black12),
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 2, top: 10, bottom: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      filteredcourseList[i].imageUrl)),
                              title: Text(
                                filteredcourseList[i].name,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black87),
                              ),
                              trailing: Chip(
                                avatar: const Icon(
                                  Icons.timer,
                                  color: Colors.black,
                                ),
                                elevation: 12,
                                backgroundColor: Colors.green.withOpacity(.7),
                                label: Text(
                                  filteredcourseList[i].duration + " hours",
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  void _onRefresh() async {
    //  print("____________________onRefreshing______________________");
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 500));
    // if failed,use refreshFailed()

    await fetchCourseData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    //  print("____________________onLoading______________________");
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 500));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    //await fetchStudentData();
    _refreshController.loadComplete();
  }

  void deleteCourse(str) async {
    FirebaseFirestore.instance.collection('courses')..doc(str).delete();
  }

  fetchCourseData() async {
    setState(() {
      processing = true;
      filteredcourseList.clear();
    });

    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('courses').get();

    final List<DocumentSnapshot> documents = result.docs;
    for (var data in documents) {
      CourseRecord record = CourseRecord(
          (data as dynamic)['name'],
          (data as dynamic)['addDate'],
          (data as dynamic)['addedBy'],
          (data as dynamic)['duration'],
          (data as dynamic)['fees'],
          (data as dynamic)['imageUrl'],
          (data as dynamic)['note'],
          data.reference,
          (data as dynamic)['syllabus'],
          (data as dynamic)['teacher']);
      courseList.add(record);
      filteredcourseList.add(record);
    }

    setState(() {
      processing = false;
    });

    filteredcourseList.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }
}
