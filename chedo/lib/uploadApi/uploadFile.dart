// ignore_for_file: must_be_immutable, avoid_print

import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'FirebaseApi.dart';

class UploadFile extends StatefulWidget {
  Function setPhotoUrl;
  String photoUrl;

  UploadFile(this.setPhotoUrl, this.photoUrl, {Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<UploadFile> {
  UploadTask? task;
  File? _imageFile;
  bool isImageSet = false;
  bool isProcessing = false;
  String photourl =
      'https://designshack.net/wp-content/uploads/placeholder-image-368x247.png';

  @override
  void initState() {
    super.initState();
    photourl = widget.photoUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: isProcessing
                ? const CircularProgressIndicator()
                : Stack(
                    children: [
                      CircularProfileAvatar(
                        photourl,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: selectFile,
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  color: Colors.green,
                                  shape: BoxShape.circle),
                              padding: const EdgeInsets.all(5),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15,
                              )),
                        ),
                      )
                    ],
                  ),
          ),
          //  task != null ? buildUploadStatus(task!) : Container(),
        ],
      ),
    );
  }

  Future selectFile() async {
    final ImagePicker _picker = ImagePicker();
    final result = await _picker.pickImage(source: ImageSource.gallery);

    if (result == null) return;
    final path = result.path;

    setState(() => _imageFile = File(path));

    uploadFile();
  }

  Future uploadFile() async {
    if (_imageFile == null) return;

    setState(() {
      isProcessing = true;
    });

    final fileName = basename(_imageFile!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, _imageFile!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    setState(() {
      isProcessing = false;
      photourl = urlDownload;
    });
    widget.setPhotoUrl(photourl);
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return percentage != '100.00'
                ? const LinearProgressIndicator()
                : const SizedBox();
          } else {
            return Container();
          }
        },
      );
}
