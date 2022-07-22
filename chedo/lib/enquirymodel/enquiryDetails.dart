// ignore_for_file: avoid_print

import 'package:chedo/data/enquiryData.dart';
import 'package:chedo/enquirymodel/followUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EnquiryDetails extends StatefulWidget {
  final EnquiryRecord record;
  const EnquiryDetails(this.record, {Key? key}) : super(key: key);
  @override
  _EnquiryDetailsState createState() => _EnquiryDetailsState();
}

class _EnquiryDetailsState extends State<EnquiryDetails> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool processing = false;
  List<FollowUpMessage> followUpNotes = [];
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    fetchNotes();

    print(widget.record.reference.id.toString());
    super.initState();
  }

  void fetchNotes() async {
    setState(() {
      followUpNotes.clear();
      processing = true;
    });
    for (var item in widget.record.followUpNotes) {
      await firestore
          .collection("enquiryDiscussionMessages")
          .doc(item)
          .get()
          .then((value) {
        FollowUpMessage fm = FollowUpMessage(
            msg: (value.data() as dynamic)['msg'],
            time: (value.data() as dynamic)['time'],
            reference: item);

        setState(() {
          followUpNotes.add(fm);
        });
      });
    }
    setState(() {
      processing = false;
    });
  }

  String getTimeView(DateTime dt) {
    String str;

    str = (dt.hour % 12).toString() +
        ':' +
        dt.minute.toString() +
        ':' +
        dt.second.toString() +
        '\t' +
        dt.day.toString() +
        '/' +
        dt.month.toString() +
        '/' +
        dt.year.toString();

    return str;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: ListTile(
              leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.arrow_back)),
              title: Text(
                widget.record.name.capitalize.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(widget.record.enqFor),
              trailing: IconButton(
                  onPressed: () {
                    launch("tel://" + widget.record.mobile);
                  },
                  icon: const Icon(
                    Icons.call,
                    color: Colors.lightGreen,
                  )),
            )),
            Expanded(
              child: Container(
                color: Colors.lightBlue.withOpacity(0.1),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: Text(widget.record.note),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: processing
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Align(
                      child: ListView.builder(
                          itemCount: followUpNotes.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          itemBuilder: (context, index) {
                            return Align(
                              alignment: Alignment.topRight,
                              child: Stack(
                                children: [
                                  InkWell(
                                    onLongPress: () {
                                      deleteEntry(
                                          followUpNotes[index].reference);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(40),
                                          bottomLeft: Radius.circular(40),
                                          topLeft: Radius.circular(20),
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(
                                          top: 15, left: 20, right: 5),
                                      padding: const EdgeInsets.all(25),
                                      child: Text(
                                        followUpNotes[index].msg.toString() +
                                            '\n',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        maxLines: 20,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      right: 20,
                                      bottom: 5,
                                      child: Text(
                                        getTimeView(
                                            followUpNotes[index].time.toDate()),
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.black38),
                                      ))
                                ],
                              ),
                            );
                          }),
                    ),
            ),
            Expanded(
                child: ListTile(
              title: TextField(
                controller: noteController,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: Colors.lightBlue.withOpacity(0.1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  prefixIcon: const Icon(Icons.sms_rounded),
                ),
              ),
              trailing: CircleAvatar(
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    size: 15,
                  ),
                  onPressed: () {
                    if (noteController.text.length > 2) {
                      addTimeLineEntry();
                      setState(() {
                        noteController.text = '';
                      });
                    }
                  },
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void addTimeLineEntry() async {
    String msg = noteController.text;
    DocumentReference referenceId =
        firestore.collection('enquiryDiscussionMessages').doc();
    await referenceId.set({
      'msg': noteController.text,
      'time': DateTime.now(),
    });

    FollowUpMessage fm = FollowUpMessage(
        msg: msg, time: Timestamp.now(), reference: referenceId.id);

    setState(() {
      followUpNotes.add(fm);
      widget.record.followUpNotes.add(referenceId.id);
    });

    firestore
        .collection('enquiryData')
        .doc(widget.record.reference.id.toString())
        .update({
      'followUp': FieldValue.arrayUnion([referenceId.id])
    }).then((value) => () {
              Get.snackbar('Success ', 'Successfull updated');
            });
  }

  void deleteEntry(String reference) async {
    await firestore
        .collection("enquiryDiscussionMessages")
        .doc(reference)
        .delete();
    firestore
        .collection('enquiryData')
        .doc(widget.record.reference.id.toString())
        .update({
      'followUp': FieldValue.arrayRemove([reference])
    }).then((value) => () {
              Get.snackbar('Success ', 'Successfull deleted');
            });
    setState(() {
      widget.record.followUpNotes.remove(reference);
    });

    fetchNotes();
  }

  // fetchEnquiryData() async {
  //   setState(() {
  //     processing = true;
  //     filteredenqList.clear();
  //   });

  //   final QuerySnapshot result =
  //       await FirebaseFirestore.instance.collection('enquiryData').get();

  //   final List<DocumentSnapshot> documents = result.docs;
  //   documents.forEach((data) {
  //     FollowUpMessage record = FollowUpMessage(
  //         msg: (data as dynamic)['msg'],
  //         time: (data as dynamic)['time'],
  //         reference: (data as dynamic)['msg']);

  //     messagesList.add(record);
  //     filteredenqList.add(record);
  //     print('_______________');
  //   });

  //   setState(() {
  //     processing = false;
  //   });

  //   filteredenqList.sort((a, b) {
  //     return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  //   });
  // }
}
