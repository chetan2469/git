// ignore_for_file: avoid_print, must_be_immutable

import 'package:chedo/data/studentNote.dart';
import 'package:chedo/studentstream/noteModule/addStudentNotes.dart';
import 'package:chedo/studentstream/noteModule/pdfViewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StudentNotesList extends StatefulWidget {
  final GoogleSignInAccount? _currentUser;
  Function handleSignout;

  StudentNotesList(this._currentUser, this.handleSignout, {Key? key})
      : super(key: key);

  @override
  _StudentNotesListState createState() => _StudentNotesListState();
}

class _StudentNotesListState extends State<StudentNotesList> {
  List<StudentNote> studentNoteList = [];
  List<StudentNote> filteredStudentNoteList = [];
  bool processing = true;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchStudentNotesData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Your Uploaded Notes')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(AddStudentNotes(widget._currentUser, widget.handleSignout));
          },
          child: const Icon(Icons.add),
        ),
        body: processing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: const WaterDropHeader(),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView.builder(
                      itemCount: filteredStudentNoteList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onLongPress: () {
                            print('deleting...' +
                                filteredStudentNoteList[index]
                                    .reference
                                    .toString());
                            removeNoteEntry(
                                filteredStudentNoteList[index].reference,
                                filteredStudentNoteList[index].fileUrl);
                          },
                          child: Container(
                            height: 70,
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(
                                top: 5, bottom: 1, left: 5, right: 5),
                            //color: Colors.grey[200],
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(width: 1, color: Colors.black12),
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: ListTile(
                              title: Text(
                                filteredStudentNoteList[index].subject,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              subtitle:
                                  Text(filteredStudentNoteList[index].chapter),
                              trailing: IconButton(
                                  onPressed: () {
                                    // print(filteredStudentNoteList[index].fileUrl);
                                    // launch(filteredStudentNoteList[index].fileUrl);
                                    print(filteredStudentNoteList[index]
                                        .fileUrl
                                        .toString());
                                    Get.to(() => PDFViewer(
                                        filteredStudentNoteList[index].chapter,
                                        filteredStudentNoteList[index]
                                            .fileUrl));
                                  },
                                  icon: const Icon(
                                    Icons.note,
                                    color: Colors.green,
                                  )),
                            ),
                          ),
                        );
                      }),
                ),
              ),
      ),
    );
  }

  fetchStudentNotesData() async {
    setState(() {
      processing = true;
      filteredStudentNoteList.clear();
      studentNoteList.clear();
    });
    final QuerySnapshot result = await firestore
        .collection('imsStudentUsers')
        .doc(widget._currentUser!.email.toString())
        .collection('uploadedNotes')
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    print(" len _-_-_-_- " + result.docs.length.toString());

    print('________________ trying to get data ________________________');
    for (var data in documents) {
      StudentNote record = StudentNote(
          chapter: (data as dynamic)['chapter'],
          fileUrl: (data as dynamic)['fileurl'],
          subject: (data as dynamic)['subject'],
          uploadTime: (data as dynamic)['uploadTime'],
          deletedByStudent: (data as dynamic)['deletedByStudent'],
          reference: data.reference);

      studentNoteList.add(record);
      filteredStudentNoteList.add(record);
    }
    print('________________ data success ________________________' +
        filteredStudentNoteList.length.toString());

    setState(() {
      processing = false;
    });

    filteredStudentNoteList.sort((a, b) {
      return a.uploadTime.compareTo(b.uploadTime);
    });
  }

  Future<void> removeNoteEntry(DocumentReference ref, String fileUrl) async {
    print("_____________________________" + ref.id.toString());
    await firestore
        .collection('imsStudentUsers')
        .doc(widget._currentUser!.email.toString())
        .collection('uploadedNotes')
        .doc(ref.id.toString())
        .delete()
        .whenComplete(() => () {
              print('deleted');
            });

    FirebaseStorage.instance
        .refFromURL(fileUrl)
        .delete()
        .then((_) => print('Successfully deleted storage item'));

    fetchStudentNotesData();
  }

  void _onRefresh() async {
    print("____________________onRefreshing______________________");
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    await fetchStudentNotesData();
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
}
