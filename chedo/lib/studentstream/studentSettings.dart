import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: must_be_immutable
class StudentSettings extends StatefulWidget {
  final GoogleSignInAccount? _currentUser;
  Function handleSignout;

  StudentSettings(this._currentUser, this.handleSignout, {Key? key})
      : super(key: key);

  @override
  _StudentSettingsState createState() => _StudentSettingsState();
}

class _StudentSettingsState extends State<StudentSettings> {
  bool darkbool = Get.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(
          brightness: Brightness.dark,
          primaryColor: Colors.purple,
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30.0),
                Row(
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              widget._currentUser!.photoUrl.toString()),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget._currentUser!.displayName.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          Text(
                            widget._currentUser!.email.toString(),
                            style: TextStyle(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ListTile(
                  title: const Text(
                    "Languages",
                  ),
                  subtitle: const Text(
                    "English US",
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey.shade400,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    "Profile Settings",
                  ),
                  subtitle: Text(
                    widget._currentUser!.displayName.toString(),
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey.shade400,
                  ),
                  onTap: () {},
                ),
                SwitchListTile(
                  title: const Text(
                    "Email Notifications",
                  ),
                  subtitle: const Text(
                    "On",
                  ),
                  value: true,
                  onChanged: (val) {},
                ),
                SwitchListTile(
                  title: const Text(
                    "Dark Mode",
                  ),
                  subtitle: Text(
                    Get.isDarkMode.toString(),
                  ),
                  value: darkbool,
                  onChanged: (val) {
                    setState(() {
                      darkbool = val;
                    });
                    Get.changeTheme(
                        Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
                  },
                ),
                ListTile(
                  title: const Text(
                    "Logout",
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    widget.handleSignout();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.back();
        },
        child: const Text('back'),
      ),
    );
  }
}
