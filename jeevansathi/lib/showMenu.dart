import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jeevansathi/bridals.dart';
import 'package:jeevansathi/cloud_firestore/addContestant.dart';
import 'package:jeevansathi/cloud_firestore/list.dart';
import 'package:jeevansathi/dataTypes/record.dart';
import 'package:jeevansathi/fireStoredemo.dart';
import 'package:jeevansathi/main.dart';
import 'constants/constants.dart';

class ShowMenu extends StatefulWidget {
  final Function _handleSignOut;
  ShowMenu(this._handleSignOut);
  @override
  _ShowMenuState createState() => _ShowMenuState();
}

class _ShowMenuState extends State<ShowMenu> {
  FirebaseUser user;
  String photourl;
  bool processing = true;
  String searchBy = 'Name';
  List<Record> candidateList = new List();
  List<Record> filteredcandidateList = new List();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final String _simpleValue1 = 'Menu item value one';
  final String _simpleValue2 = 'Menu item value two';
  final String _simpleValue3 = 'Menu item value three';
  String _simpleValue;

  final cFirebaseAuth = FirebaseAuth.instance;
  final cGoogleSignIn = GoogleSignIn();

  fetchcandidateList() async {
    setState(() {
      processing = true;
      filteredcandidateList.clear();
    });
    final QuerySnapshot result =
        await Firestore.instance.collection('SAK').getDocuments();

    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      final record = Record.fromSnapshot(data);
      candidateList.add(record);
      filteredcandidateList.add(record);
    });

    setState(() {
      processing = false;
    });

    filteredcandidateList.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
  }

  sortBy() {
    if (searchBy == 'Name') {
      filteredcandidateList.sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } else if (searchBy == 'Date Of Birth') {
      filteredcandidateList.sort((a, b) {
        return a.dob
            .toString()
            .toLowerCase()
            .compareTo(b.dob.toString().toLowerCase());
      });
    } else if (searchBy == 'City') {
      filteredcandidateList.sort((a, b) {
        return a.birthPlace.toLowerCase().compareTo(b.birthPlace.toLowerCase());
      });
    } else if (searchBy == 'SAK-APP ID') {
      filteredcandidateList.sort((a, b) {
        return a.sakId.toLowerCase().compareTo(b.sakId.toLowerCase());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cFirebaseAuth.currentUser().then(
          (user) => setState(() {
            this.user = user;
          }),
        );
    if (candidateList.length < 10 || filteredcandidateList.length < 10) {
      fetchcandidateList();
    }
  }

  void showMenuSelection(String value) {
    if (<String>[_simpleValue1, _simpleValue2, _simpleValue3].contains(value))
      _simpleValue = value;
    showInSnackBar('You selected: $value');

    if (value == 'LogOut') {
      widget._handleSignOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: processing
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(10),
                                  alignment: Alignment.centerLeft,
                                  child: Icon(FontAwesomeIcons.alignLeft),
                                ),
                                InkWell(
                                  onTap: () {
                                    print(candidateList.length);
                                    print(filteredcandidateList.length);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset('assets/sakRed.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Icon(FontAwesomeIcons.search),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: PopupMenuButton<String>(
                                    icon: Container(
                                      alignment: Alignment.centerRight,
                                      // child: CircleAvatar(
                                      //   backgroundImage: NetworkImage(user.photoUrl),
                                      // ),
                                    ),
                                    onSelected: showMenuSelection,
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuItem<String>>[
                                      const PopupMenuItem<String>(
                                        value: 'Profile',
                                        child: Text('Profile'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'Messages',
                                        child: Text('Messages'),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'LogOut',
                                        child: Text('LogOut'),
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: EdgeInsets.only(top: 30, bottom: 10),
                      child: Image.asset('assets/couple.png'),
                    ),
                  ),
                  Expanded(
                      flex: 5,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(60),
                                            bottomLeft: Radius.circular(60),
                                            topLeft: Radius.circular(60))),
                                    margin:
                                        EdgeInsets.only(right: 2, bottom: 2),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.all(1),
                                        child: ListTile(
                                          title: Text(
                                            'Add Profile',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          leading: Icon(
                                            FontAwesomeIcons.user,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ListPage()));
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 2, bottom: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(60),
                                              bottomRight: Radius.circular(60),
                                              topLeft: Radius.circular(60))),
                                      child: Center(
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          child: ListTile(
                                            title: Text(
                                              'Help',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            leading: Icon(
                                              FontAwesomeIcons.whatsapp,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FireStoreDemo()));
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(right: 2, bottom: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(60),
                                              bottomRight: Radius.circular(60),
                                              topLeft: Radius.circular(60))),
                                      child: Center(
                                        child: Container(
                                          margin: EdgeInsets.all(1),
                                          child: ListTile(
                                            title: Text(
                                              'Find Groom',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            leading: Icon(
                                              FontAwesomeIcons.male,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Bride(
                                                  filteredcandidateList,
                                                  fetchcandidateList)));
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(left: 2, bottom: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.pink,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(60),
                                              bottomRight: Radius.circular(60),
                                              bottomLeft: Radius.circular(60))),
                                      child: Center(
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          child: ListTile(
                                            title: Text(
                                              'Find Bridal',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            leading: Icon(
                                              FontAwesomeIcons.female,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ))
                ],
              )),
      ),
    );
  }
}
