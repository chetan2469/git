// ignore_for_file: must_be_immutable

import 'package:chedo/data/mcqData.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GetExam extends StatefulWidget {
  final GoogleSignInAccount? _currentUser;
  List<MCQData> filteredMcqDataList;
  GetExam(this._currentUser, this.filteredMcqDataList, {Key? key})
      : super(key: key);

  @override
  _GetExamState createState() => _GetExamState();
}

class _GetExamState extends State<GetExam> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: const Icon(Icons.person_outline),
            title: const Text(
              'DASHBOARD',
              style: TextStyle(fontSize: 16.0),
            ),
            bottom: PreferredSize(
                child: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    indicatorColor: Colors.white,
                    // ignore: prefer_const_literals_to_create_immutables
                    tabs: [
                      const Tab(
                        child: Text('Tab 1'),
                      ),
                      const Tab(
                        child: Text('Investment'),
                      ),
                      const Tab(
                        child: Text('Your Earning'),
                      ),
                      const Tab(
                        child: Text('Current Balance'),
                      ),
                      const Tab(
                        child: Text('Tab 5'),
                      ),
                      const Tab(
                        child: Text('Tab 6'),
                      )
                    ]),
                preferredSize: const Size.fromHeight(30.0)),
            // ignore: prefer_const_literals_to_create_immutables
            actions: <Widget>[
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.add_alert),
              ),
            ],
          ),
          body: const TabBarView(
            children: <Widget>[
              Center(
                child: Text('anila'),
              ),
              Center(
                child: Text('Tab 2'),
              ),
              Center(
                child: Text('Tab 3'),
              ),
              Center(
                child: Text('Tab 4'),
              ),
              Center(
                child: Text('Tab 5'),
              ),
              Center(
                child: Text('Tab 6'),
              ),
            ],
          )),
    );
  }
}
