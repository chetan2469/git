// ignore_for_file: avoid_print, must_be_immutable

import 'package:chedo/questionData/mcqGlobleData.dart';
import 'package:chedo/usersModel/AppUsersList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chedo/student_module/addmission.dart';
import 'package:chedo/student_module/studentListView.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/cupertino.dart';

import 'course_module/courseList.dart';
import 'enquirymodel/enquiryDashboard.dart';

class ShowMenu extends StatefulWidget {
  final Function _handleSignOut;
  final GoogleSignInAccount? _currentUser;

  const ShowMenu(this._handleSignOut, this._currentUser, {Key? key})
      : super(key: key);

  @override
  _ShowMenu createState() => _ShowMenu();
}

class _ShowMenu extends State<ShowMenu> {
  //FirebaseUser user;
  bool darkMode = false;
  String photourl =
      'https://chedo.in/wp-content/uploads/2020/05/2020-landscape-1.png';
  String enqFormUrl =
      "https://docs.google.com/forms/d/e/1FAIpQLSez0X0Ja72aPveJVYzUiVWAb6YGwAhMJ8LrfXu_9Q3U-dhxhw/viewform";
  String enqUrl =
      "https://docs.google.com/spreadsheets/d/1Nhc9AAdfBI0cMqBOJ367w_L6_hsH0OCBvfXMSjrzJcE/edit#gid=79772504";

  @override
  void initState() {
    super.initState();
  }

  onThemeChange() {
    if (darkMode) {
      setState(() {
        Get.changeThemeMode(ThemeMode.dark);
      });
    } else {
      setState(() {
        Get.changeThemeMode(ThemeMode.light);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: menuDrawer(context),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                color: Colors.white,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        left: 20,
                        top: 55,
                        child: SizedBox(
                            width: 90,
                            height: 90,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  widget._currentUser!.photoUrl.toString()),
                            ))),
                    Positioned(
                        right: 20,
                        top: 50,
                        child: InkWell(
                            onTap: () {
                              //_scaffoldKey.currentState!.openDrawer();
                            },
                            child: dropMenu()))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    AddStudInfo(widget._currentUser)));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(200, 90, 150, 239),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        //color: Color.fromARGB(200, 90, 150, 239),
                        child: const Center(
                          child: Text(
                            "ADMISSION",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        Get.to(AppUsersList());
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(200, 90, 150, 239),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        //color: Color.fromARGB(200, 90, 150, 239),
                        child: const Center(
                          child: Text(
                            "USERS",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Get.to(() => const EnquiryDashboard());
                          //  Get.to(ParseJson());
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //         builder: (context) =>
                          //             WebViewContainer(enqFormUrl)));
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(210, 25, 25, 112),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        //color: Color.fromARGB(210, 25, 25, 112),
                        child: const Center(
                          child: Text(
                            "Enquiries",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      const StudentListView()));
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(162, 106, 99, 245),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        //color: Color.fromARGB(162, 106, 99, 245),
                        child: const Center(
                          child: Text(
                            "STUDENT LIST",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.to(CourseListView(widget._currentUser));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(151, 255, 66, 66),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: const Center(
                          child: Text(
                            "COURSES",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.defaultDialog(
                            title: 'select Course',
                            content: Column(
                              children: [
                                const Divider(),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    Get.to(McqGlobalData(widget._currentUser,
                                        'C Programming', true));
                                  },
                                  child: const Text('C Programming'),
                                ),
                                const Divider(),
                              ],
                            ));
                        //
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(222, 26, 222, 245),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        //color: Color.fromARGB(162, 106, 99, 245),
                        child: const Center(
                          child: Text(
                            "MCQ",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      const StudentListView()));
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(92, 16, 119, 245),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        //color: Color.fromARGB(162, 106, 99, 245),
                        child: const Center(
                          child: Text(
                            "RECEIPTS",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        widget._handleSignOut();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(111, 55, 66, 66),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        child: const Center(
                          child: Text(
                            "LOGOUT",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        height: 10,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 150,
                    ),
                    Container(
                      color: Colors.grey[300],
                      height: 40,
                    ),
                    Center(
                      child: FloatingActionButton(
                        backgroundColor: Colors.blue,
                        onPressed: () {
                          var media = MediaQuery.of(context);
                          print(media.size.width);
                          print(media.size.height);
                        },
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  void selectedChoice(String s) {
    if (s == 'Profile') {
    } else if (s == 'Setting') {
    } else if (s == 'Contact') {
    } else if (s == 'Logout') {
      setState(() {
        widget._handleSignOut();
      });
    }
  }

  Widget dropMenu() {
    return Container(
      margin: const EdgeInsets.only(top: 45, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            width: 30,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(20)),
          ),
        ],
      ),
    );
  }

  Widget menuDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 20, left: 20),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black12,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(photourl),
                  ),
                )),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: ListTile(
                title: const Text(
                  "Night Mode",
                  style: TextStyle(fontSize: 20, color: Colors.black38),
                ),
                trailing: Switch(
                  value: darkMode,
                  onChanged: (bool b) {
                    setState(() {
                      darkMode = b;
                    });
                    onThemeChange();
                  },
                ),
              ),
            ),
            Container(
              height: 2,
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
              color: Colors.grey,
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(220, 25, 25, 112),
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const StudentListView()));
                },
                leading: const Icon(
                  Icons.face,
                  color: Colors.white,
                  size: 30,
                ),
                title: const Text(
                  "Student",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(212, 106, 99, 245),
                  borderRadius: BorderRadius.circular(12)),
              child: const ListTile(
                leading: Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  "Teacher",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(221, 255, 66, 66),
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     CupertinoPageRoute(
                  //         builder: (context) => CourseListView()));
                },
                leading: const Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 30,
                ),
                title: const Text(
                  "Course",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(210, 90, 150, 239),
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                onTap: () {
                  // Navigator.push(context,
                  //     CupertinoPageRoute(builder: (context) => Receipt()));
                },
                leading: const Icon(
                  Icons.book,
                  color: Colors.white,
                  size: 30,
                ),
                title: const Text(
                  "Receipt",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () {},
                child: const ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 30,
                  ),
                  title: Text(
                    "Setting",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: 2,
              margin: const EdgeInsets.only(top: 5, left: 20, right: 20),
              color: Colors.grey,
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12)),
              child: InkWell(
                onTap: () async {
                  //        final user = await FirebaseAuth.instance.currentUser();
                  Get.snackbar('Alert', 'Logging Off');
                  FirebaseAuth.instance.signOut();
                  widget._handleSignOut();
                  //     widget._currentUser!.clearAuthCache();
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.developer_board,
                    color: Colors.white,
                    size: 30,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: 2,
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // _launchURL() async {
  //   const url =
  //       'https://docs.google.com/spreadsheets/d/1Nhc9AAdfBI0cMqBOJ367w_L6_hsH0OCBvfXMSjrzJcE/edit#gid=79772504';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}
