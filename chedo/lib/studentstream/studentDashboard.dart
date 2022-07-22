// ignore_for_file: avoid_print, must_be_immutable

import 'package:chedo/data/studentAdmissionRecord.dart';
import 'package:chedo/data/studentCourseEntry.dart';
import 'package:chedo/player/Player.dart';
import 'package:chedo/questionData/mcqGlobalDataOfflineSupport.dart';
import 'package:chedo/questionData/mcqContribution.dart';
import 'package:chedo/studentstream/noteModule/studentsNotesList.dart';
import 'package:chedo/studentstream/studentSettings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class StudentDashboard extends StatefulWidget {
  final GoogleSignInAccount? _currentUser;
  Function handleSignout;

  String ref;

  StudentDashboard(this._currentUser, this.handleSignout, this.ref, {Key? key})
      : super(key: key);
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  bool isEditor = false, processing = false, isGuest = false;

  late StudentAdmissionRecord record;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<StudentCourseEntry> studentCourseList = [];

  @override
  void initState() {
    // _currentPage = 0;

    if (widget.ref == "xReQTZ8R7Mvg88o4HIxH") {
      setState(() {
        isGuest = true;
      });
    }
    loadStudentData();
    checkIsEditor();
    // ignore: avoid_print
    print('________' + widget.ref);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: processing
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: <Widget>[
                    _buildHeader(),
                    const SizedBox(height: 20.0),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Progress",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ),

                    Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(YoutubePlaye());
                              },
                              child: ListTile(
                                leading: Container(
                                  alignment: Alignment.bottomCenter,
                                  width: 45.0,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        height: 20,
                                        width: 8.0,
                                        color: Colors.pink.shade300,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Container(
                                        height: 25,
                                        width: 8.0,
                                        color: Colors.grey.shade300,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Container(
                                        height: 40,
                                        width: 8.0,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Container(
                                        height: 30,
                                        width: 8.0,
                                        color: Colors.grey.shade300,
                                      ),
                                    ],
                                  ),
                                ),
                                title: const Text("Score"),
                                subtitle: const Text("..."),
                              ),
                            ),
                          ),
                          const VerticalDivider(),
                          Expanded(
                            child: ListTile(
                              leading: Container(
                                alignment: Alignment.bottomCenter,
                                width: 45.0,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      width: 8.0,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Container(
                                      height: 25,
                                      width: 8.0,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Container(
                                      height: 40,
                                      width: 8.0,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 4.0),
                                    Container(
                                      height: 30,
                                      width: 8.0,
                                      color: Colors.grey.shade300,
                                    ),
                                  ],
                                ),
                              ),
                              title: const Text("Test"),
                              subtitle: const Text("7"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: InkWell(
                              onTap: () {},
                              child: _buildTile(
                                color: isEditor
                                    ? Colors.green[300]
                                    : Colors.redAccent,
                                icon: Icons.check_circle_outlined,
                                title: isEditor ? 'Congratulations' : 'Student',
                                data: isEditor
                                    ? 'You are now scholar student . now you have extra power to review other students questions.  remember power comes with responsiblities. '
                                    : 'This app is for your skills to improve. do more practice... \n Best Of Luck',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (!isGuest) {
                                  Get.to(MCQContribution(widget._currentUser));
                                } else {
                                  Get.snackbar(
                                      "Alert", "you cannot add questions");
                                }
                              },
                              child: _buildTile(
                                color: Colors.black45,
                                icon: Icons.portrait,
                                title: "My MCQ",
                                data: "add your own mcq",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //               Get.to(McqGlobalData(widget._currentUser,'C Programming',false));
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.defaultDialog(
                                    title: 'select Course',
                                    content: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                            Get.to(McqGlobalDataOfflineSupport(
                                                widget._currentUser,
                                                'C Programming',
                                                isEditor,
                                                isGuest));
                                          },
                                          child: const ListTile(
                                            title: Text('C Programming'),
                                          ),
                                        ),
                                        const Divider(),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                            Get.to(McqGlobalDataOfflineSupport(
                                                widget._currentUser,
                                                'C++ Programming',
                                                isEditor,
                                                isGuest));
                                          },
                                          child: const ListTile(
                                            title: Text('C++ Programming'),
                                          ),
                                        ),
                                        const Divider(),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                            Get.to(McqGlobalDataOfflineSupport(
                                                widget._currentUser,
                                                'Data Structure',
                                                isEditor,
                                                isGuest));
                                          },
                                          child: const ListTile(
                                            title: Text('Data Structure'),
                                          ),
                                        ),
                                        const Divider(),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                            Get.to(McqGlobalDataOfflineSupport(
                                                widget._currentUser,
                                                'Python',
                                                isEditor,
                                                isGuest));
                                          },
                                          child: const ListTile(
                                            title: Text('Python'),
                                          ),
                                        ),
                                        const Divider(),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                            Get.to(McqGlobalDataOfflineSupport(
                                                widget._currentUser,
                                                'Java',
                                                isEditor,
                                                isGuest));
                                          },
                                          child: const ListTile(
                                            title: Text('Java (core)'),
                                          ),
                                        ),
                                        const Divider(),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                            Get.to(McqGlobalDataOfflineSupport(
                                                widget._currentUser,
                                                'CS-11',
                                                isEditor,
                                                isGuest));
                                          },
                                          child: const ListTile(
                                            title:
                                                Text('Computer Science (11)'),
                                          ),
                                        ),
                                        const Divider(),
                                        InkWell(
                                          onTap: () {
                                            Get.back();
                                            Get.to(McqGlobalDataOfflineSupport(
                                                widget._currentUser,
                                                'CS-11',
                                                isEditor,
                                                isGuest));
                                          },
                                          child: const ListTile(
                                            title:
                                                Text('Computer Science (12)'),
                                          ),
                                        ),
                                      ],
                                    ));
                                //Get.to(AddMcq(widget._currentUser));
                                // Get.snackbar('Note', 'this feature is Comming Soon....',
                                //     snackPosition: SnackPosition.BOTTOM);
                              },
                              child: _buildTile(
                                color: Colors.blue,
                                icon: Icons.book,
                                title: "Test",
                                data: 'take a test  ',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (!isGuest) {
                                  Get.to(StudentNotesList(widget._currentUser,
                                      widget.handleSignout));
                                } else {
                                  Get.snackbar("Alert",
                                      "you cannot upload your notes only chedo student can do it.");
                                }
                              },
                              child: _buildTile(
                                color: Colors.pink,
                                icon: Icons.note_add,
                                title: "Notes",
                                data: "upload your notes",
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(StudentSettings(
                                    widget._currentUser, widget.handleSignout));
                              },
                              child: _buildTile(
                                color: Colors.blue,
                                icon: Icons.settings,
                                title: "Settings",
                                data: 'Dark Mode ' + Get.isDarkMode.toString(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                )),
    );
  }

  Container _buildHeader() {
    // ignore: prefer_const_declarations
    final TextStyle whiteText = const TextStyle(color: Colors.white);
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 32.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        color: isEditor ? Colors.green : Colors.blue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              "Dashboard",
              style: whiteText.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 30.0),
            ),
            trailing: CircleAvatar(
              radius: 35.0,
              backgroundImage: NetworkImage(record.imageurl),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              '' + record.name,
              style: whiteText.copyWith(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'DOB : ' + record.dateofbirth.toDate().toString().split(' ')[0],
              style: whiteText,
            ),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'Mob : ' + record.mobileno + ' \t/\t ' + record.optionalno,
              style: whiteText,
            ),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'AADHAR : ' + record.aadharno,
              style: whiteText,
            ),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'ADDRESS : ' + record.address,
              style: whiteText,
            ),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              'My Courses : ' + getCourseList(),
              style: whiteText,
            ),
          ),
        ],
      ),
    );
  }

  String getCourseList() {
    String courses = '';
    for (var course in studentCourseList) {
      courses = " " + courses + course.course_name + ', ';
    }
    return courses;
  }

  Container _buildTile(
      {Color? color,
      IconData? icon,
      required String title,
      required String data}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            data,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  loadStudentData() async {
    setState(() {
      processing = true;
    });
    var collection = FirebaseFirestore.instance.collection('admission');
    var docSnapshot = await collection.doc(widget.ref).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        // ignore: unnecessary_this
        this.record = StudentAdmissionRecord(
            aadharno: data?['aadharNo'],
            addDate: data?['addDate'],
            address: data?['address'],
            batchtime: data?['batchTime'],
            courses: data?['courses'],
            dateofbirth: data?['dateOfBirth'],
            imageurl: data?['imageUrl'],
            mobileno: data?['mobileNo'],
            name: data?['name'],
            optionalno: data?['optNumber'],
            outStandingAmount: data?['outStandingAmount'],
            pursuing_course: data?['pursuing_course'],
            reference: docSnapshot.reference,
            status: data?['status']);
      });

      // print(record.name + "______________");

      checkIsEditor();
      setState(() {
        processing = false;
      });
    }
    fetchStudentCourseList();
  }

  void fetchStudentCourseList() async {
    //fetch receipts and courses list from array refrences
    for (var i = 0; i < record.courses.length; i++) {
      FirebaseFirestore.instance
          .collection('student_course')
          .doc(record.courses[i].toString())
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
          studentCourseList.add(e);
        });
      });
    }
  }

  void checkIsEditor() async {
    var docSnapshot = await firestore
        .collection('imsStudentUsers')
        .doc(widget._currentUser!.email.toString())
        .get();

    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      try {
        setState(() {
          isEditor = data?['isEditor'];
        });
      } catch (e) {
        setState(() {
          isEditor = false;
        });
      }
    }
  }
}
