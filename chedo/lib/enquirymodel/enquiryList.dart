// ignore_for_file: avoid_print

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chedo/data/enquiryData.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'enquiryDetails.dart';
import 'enquiryFrom.dart';

// ignore: must_be_immutable
class EnquiryListView extends StatefulWidget {
  List<EnquiryFromOption> enqFromList;
  EnquiryListView(this.enqFromList, {Key? key}) : super(key: key);

  @override
  _EnquiryListViewState createState() => _EnquiryListViewState();
}

class _EnquiryListViewState extends State<EnquiryListView> {
  List<EnquiryRecord> enqList = [];
  List<EnquiryRecord> filteredenqList = [];
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
    fetchEnquiryData();
  }

  String findWnqFromUrl(String enqFromName) {
    final index =
        widget.enqFromList.indexWhere((element) => element.name == enqFromName);

    return widget.enqFromList[index].imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Icon(Icons.add),
        //   backgroundColor: Colors.indigo,
        // ),
        body: Column(
          children: [
            Expanded(
                child: ListTile(
              title: const Text(
                'Enquiry Student List',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back)),
            )),
            Expanded(
                flex: 10,
                child: Container(
                  margin: const EdgeInsets.all(6),
                  child: processing
                      ? const Center(child: CircularProgressIndicator())
                      : SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          header: const WaterDropHeader(),
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          child: ListView.builder(
                            itemCount: filteredenqList.length,
                            itemBuilder: (BuildContext cotext, int i) {
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(() =>
                                          EnquiryDetails(filteredenqList[i]));
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: ListTile(
                                        leading: CachedNetworkImage(
                                          width: 40,
                                          imageUrl: findWnqFromUrl(
                                              filteredenqList[i].enqFrom),
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        title: Text(
                                          filteredenqList[i].name,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87),
                                        ),
                                        subtitle: Text(
                                          filteredenqList[i].enqFor,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87),
                                        ),
                                        trailing: Column(
                                          children: [
                                            Text(
                                              DateTime.fromMillisecondsSinceEpoch(
                                                          filteredenqList[i]
                                                              .enqDate
                                                              .millisecondsSinceEpoch)
                                                      .day
                                                      .toString() +
                                                  ' / ' +
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                          filteredenqList[i]
                                                              .enqDate
                                                              .millisecondsSinceEpoch)
                                                      .month
                                                      .toString() +
                                                  ' / ' +
                                                  DateTime.fromMillisecondsSinceEpoch(
                                                          filteredenqList[i]
                                                              .enqDate
                                                              .millisecondsSinceEpoch)
                                                      .year
                                                      .toString(),
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                            Container(
                                                margin: const EdgeInsets.all(5),
                                                child: const Icon(
                                                  Icons.donut_small,
                                                  color: Colors.red,
                                                  size: 20,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider()
                                ],
                              );
                            },
                          ),
                        ),
                ))
          ],
        ),
      ),
    );
  }

  void _onRefresh() async {
    print("____________________onRefreshing______________________");
    await Future.delayed(const Duration(milliseconds: 500));

    await fetchEnquiryData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    print("____________________onLoading______________________");
    await Future.delayed(const Duration(milliseconds: 500));
    _refreshController.loadComplete();
  }

  fetchEnquiryData() async {
    setState(() {
      processing = true;
      filteredenqList.clear();
    });

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('enquiryData')
        .orderBy("enquiryDate", descending: true)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    String name, mobile, enqFrom, enqFor, note;
    Timestamp enqDate, prefTime;

    for (var data in documents) {
      try {
        name = (data as dynamic)['name'];
      } on Exception {
        name = 'null';
      }

      try {
        mobile = (data as dynamic)['mobileNo'];
      } on Exception {
        mobile = 'null';
      }

      try {
        enqFrom = (data as dynamic)['enquiryFrom'];
      } on Exception {
        enqFrom = 'null';
      }

      try {
        enqFor = (data as dynamic)['enquiryFor'];
      } on Exception {
        enqFor = 'null';
      }

      try {
        note = (data as dynamic)['note'];
      } on Exception {
        note = 'null';
      }

      try {
        enqDate = (data as dynamic)['enquiryDate'];
      } on Exception {
        enqDate = Timestamp.fromMillisecondsSinceEpoch(1);
      }

      try {
        prefTime = (data as dynamic)['prefTime'];
      } on Exception {
        prefTime = Timestamp.fromMillisecondsSinceEpoch(1);
      }

      try {} on Exception {}

      EnquiryRecord record = EnquiryRecord(name, mobile, enqFrom, enqFor, note,
          enqDate, prefTime, (data as dynamic)['followUp'], data.reference);

      enqList.add(record);
      filteredenqList.add(record);
      print('_______________');
    }

    setState(() {
      processing = false;
    });

    // filteredenqList.sort((a, b) {
    //   return a.enqDate.compareTo(b.enqDate);
    // });
  }
}
