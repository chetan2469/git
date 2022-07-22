// ignore_for_file: avoid_print

import 'dart:io';
import 'package:chedo/uploadApi/FirebaseApi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddStudentNotes extends StatefulWidget {
  final GoogleSignInAccount? _currentUser;
  Function handleSignout;

  AddStudentNotes(this._currentUser, this.handleSignout, {Key? key})
      : super(key: key);

  @override
  _AddStudentNotesState createState() => _AddStudentNotesState();
}

class _AddStudentNotesState extends State<AddStudentNotes> {
  UploadTask? task;
  File? file;
  String filePath = '';
  late String fileDounloadUrl;

  TextEditingController chapterController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController fileNameController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fileNameController.text = "click icon to select file";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: task != null
          ? Center(child: buildUploadStatus(task!))
          : ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  child: const Center(
                      child: Text(
                    "Upload Your Note Here",
                    style: TextStyle(fontSize: 20),
                  )),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 10),
                  child: TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(),
                      labelText: 'Subject Name',
                      // ignore: unnecessary_const
                      prefixIcon: const Icon(
                        Icons.note,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 10),
                  child: TextField(
                    controller: chapterController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      border: OutlineInputBorder(),
                      labelText: 'Chapter Name',
                      prefixIcon: Icon(
                        Icons.subject,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 10, left: 20, right: 20, bottom: 10),
                  child: TextField(
                    readOnly: true,
                    controller: fileNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      border: const OutlineInputBorder(),
                      prefixIcon: IconButton(
                          onPressed: () {
                            if (subjectController.text.length > 4 &&
                                chapterController.text.length > 4) {
                              selectFile();
                            } else {
                              Get.snackbar(
                                'Warning',
                                'Please fill Subject and Chapter name first',
                                backgroundColor: Colors.black,
                                colorText: Colors.white,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.upload_file,
                            color: Colors.green,
                          )),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width / 4),
                  child: ListTile(
                      leading: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back))),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: uploadFile,
        child: const Icon(Icons.upload_file),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));

    print('____________________');
    print(file!.lengthSync());

    if (file!.lengthSync() < 10038042) {
      setState(() {
        filePath = result.files.single.path!;
      });

      String extension = filePath
          .toString()
          .split('/')[filePath.toString().split('/').length - 1]
          .toString();

      setState(() {
        extension = extension.substring(extension.length - 4, extension.length);
      });
      print(extension);

      if (extension != '.pdf') {
        setState(() {
          filePath = '';
          file = null;
        });
        Get.snackbar('Warning !!', 'File must be in pdf format',
            backgroundColor: Colors.black, colorText: Colors.white);
      } else {
        setState(() {
          fileNameController.text = filePath
              .toString()
              .split('/')[filePath.toString().split('/').length - 1]
              .toString();
        });
      }
    } else {
      Get.snackbar(
        'Warning !!',
        'File size should be less than 10 mb',
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
    }
  }

  Future uploadFile() async {
    if (file == null) {
      Get.snackbar(
        'Warning !!',
        'Please select File',
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
      return;
    }

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      fileDounloadUrl = urlDownload;
    });

    print('Download-Link: $urlDownload');
    print('calling to store element...');
    insertDataToServer();
    print('after to store element...');
    Get.back();
  }

  insertDataToServer() async {
    await firestore
        .collection('imsStudentUsers')
        .doc(widget._currentUser!.email.toString())
        .collection('uploadedNotes')
        .doc()
        .set({
      'subject': subjectController.text,
      'chapter': chapterController.text,
      'fileurl': fileDounloadUrl,
      'uploadTime': DateTime.now(),
      'deletedByStudent': false
    });
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    '$percentage %',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      );
}
