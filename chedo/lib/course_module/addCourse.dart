import 'package:chedo/uploadApi/uploadFile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class AddCourse extends StatefulWidget {
  final GoogleSignInAccount? _currentUser;
  const AddCourse(this._currentUser, {Key? key}) : super(key: key);
  @override
  _AddCourse createState() => _AddCourse();
}

class _AddCourse extends State<AddCourse> {
  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController feesController = TextEditingController();
  TextEditingController syllabusController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  bool nameValidator = true,
      feesValidator = true,
      durationValidator = true,
      teacherNameValidator = true,
      syllabusValidator = true,
      noteValidator = true;
  bool isImageSet = false;
  bool processing = false;
  String thumbnail =
      'https://designshack.net/wp-content/uploads/placeholder-image-368x247.png';
  double compressValue = 40;
  late String url;

  // Future<Null> _pickImageFromGallery() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  //   //imageFile.rename('');
  //   setState(() {
  //     this._imageFile = File(image!.path);
  //     isImageSet = true;
  //   });
  //   // compressFile(_imageFile, _imageFile.path);
  //   print('calling getImageUrl()');
  //   //  uploadFile();
  //   print('after image upload getImageUrl()');
  // }

  // Future<Null> _pickImageFromCamera() async {
  //   final XFile? image = await _picker.pickImage(source: ImageSource.camera);

  //   //imageFile.rename('');
  //   setState(() {
  //     this._imageFile = File(image!.path);
  //     isImageSet = true;
  //   });
  //   compressFile(_imageFile, _imageFile.path);
  // }

  // // Future<Null> _pickImageFromCamera() async {
  // //   File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  // //   print("________________FILE______________");
  // //   imageFile = await compressFile(imageFile, imageFile.path);
  // //   setState(() => this._imageFile = imageFile);
  // // }

  compressFile(File file, String targetPath) async {
//  print('target path = ' + targetPath);
    setState(() {
      targetPath =
          targetPath.substring(0, (targetPath.length - 4)) + 'min' + '.jpg';
    });

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: int.parse(compressValue.toString().split('.')[0].toString()),
    );
    setState(() {});
    //  print('_________________________' + _imageFile.lengthSync().toString());

    return result;
  }

  checkSize() {
    //  print(_imageFile.lengthSync());
  }

  // _showDialog(BuildContext context) async {
  //   await showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return SimpleDialog(
  //           children: <Widget>[
  //             InkWell(
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 setState(() {
  //                   _pickImageFromCamera();
  //                 });
  //               },
  //               child: ListTile(
  //                 leading: Icon(Icons.camera_alt),
  //                 title: Text(
  //                   'Camera',
  //                   style: TextStyle(fontSize: 20),
  //                 ),
  //               ),
  //             ),
  //             InkWell(
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 setState(() {
  //                   _pickImageFromGallery();
  //                 });
  //               },
  //               child: ListTile(
  //                 leading: Icon(Icons.image),
  //                 title: Text(
  //                   'Gallery',
  //                   style: TextStyle(fontSize: 20),
  //                 ),
  //               ),
  //             )
  //           ],
  //         );
  //       });
  // }

  // Future<void> _uploadFile() async {
  //   setState(() {
  //     processing = true;
  //   });
  //   int __rand = new Math.Random().nextInt(10000);

  //   final Directory systemTempDir = Directory.systemTemp;
  //   String __tempName = nameController.text, __date = DateTime.now().toString();

  //   final StorageReference ref = FirebaseStorage.instance
  //       .ref()
  //       .child("$__tempName _ $__date _ $__rand.jpg");

  //   final StorageUploadTask uploadTask = ref.put(_imageFile);

  //   var downurl = await (await uploadTask.onComplete).ref.getDownloadURL();
  //   thumbnail = downurl.toString();
  //   print(thumbnail);
  //   insert();
  //   setState(() {
  //     processing = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    setState(() {
      processing = false;
    });

    // cFirebaseAuth.currentUser().then(
    //       (user) => setState(() {
    //         this.user = user;
    //       }),
    //     );
  }

  setPhotoUrl(String str) {
    setState(() {
      thumbnail = str;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(171, 255, 66, 66),
        title: const Text(
          "Add Course",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton(
        child: processing
            ? const CircularProgressIndicator(
                backgroundColor: Colors.white,
              )
            : const Icon(
                Icons.add,
              ),
        onPressed: () {
          if (nameController.text.isNotEmpty &&
              feesController.text.isNotEmpty &&
              durationController.text.isNotEmpty &&
              teacherController.text.isNotEmpty &&
              syllabusController.text.isNotEmpty &&
              thumbnail.isNotEmpty) {
            setState(() {
              processing = true;
            });
            insert();
          }
        },
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Center(
          child: ListView(
            children: <Widget>[
              UploadFile(setPhotoUrl, thumbnail),
              thumbnail.isNotEmpty
                  ? Text(
                      thumbnail.toString(),
                      style: const TextStyle(fontSize: 1),
                    )
                  : Container(),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: nameController,
                onChanged: (String str1) {
                  if (str1.length < 3) {
                    setState(() {
                      nameValidator = false;
                    });
                  } else {
                    setState(() {
                      nameValidator = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white70,
                  labelStyle: const TextStyle(
                    color: Colors.black54,
                  ),
                  errorText: !nameValidator
                      ? "Name Should be greater than 3 characters"
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  labelText: "Name",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: feesController,
                        onChanged: (String str2) {
                          if (str2.length < 3) {
                            setState(() {
                              feesValidator = false;
                            });
                          } else {
                            setState(() {
                              feesValidator = true;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                          ),
                          errorText: !feesValidator
                              ? "Please Insert Fees of Course"
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "Fees",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: durationController,
                        onChanged: (String str3) {
                          if (str3.length < 2) {
                            setState(() {
                              durationValidator = false;
                            });
                          } else {
                            setState(() {
                              durationValidator = true;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                          ),
                          errorText: !durationValidator
                              ? "Please Insert Duration of Course"
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          labelText: "Duration in Hours",
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: teacherController,
                onChanged: (String str5) {
                  if (str5.length < 4) {
                    setState(() {
                      teacherNameValidator = false;
                    });
                  } else {
                    setState(() {
                      teacherNameValidator = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white70,
                  labelStyle: const TextStyle(
                    color: Colors.black54,
                  ),
                  errorText: !teacherNameValidator
                      ? "Insert Teacher name for Course"
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Teacher Name",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: 10,
                controller: syllabusController,
                onChanged: (String str5) {
                  if (str5.length < 12) {
                    setState(() {
                      syllabusValidator = false;
                    });
                  } else {
                    setState(() {
                      syllabusValidator = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white70,
                  labelStyle: const TextStyle(
                    color: Colors.black54,
                  ),
                  errorText: !syllabusValidator
                      ? "Insert Teacher name for Course"
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Syllabus",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: noteController,
                onChanged: (String str5) {
                  if (str5.length < 2) {
                    setState(() {
                      noteValidator = true;
                      noteController.text = 'NO';
                    });
                  } else {
                    setState(() {
                      noteValidator = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "note",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void insert() async {
    //  print('_________ trying insert___________');
    FirebaseFirestore.instance.collection('courses').doc().set({
      'name': nameController.text,
      'fees': feesController.text,
      'duration': durationController.text,
      'teacher': teacherController.text,
      'syllabus': syllabusController.text,
      'note': noteController.text,
      'addDate': DateTime.now(),
      'imageUrl': thumbnail,
      'addedBy': widget._currentUser!.email.toString(),
    });
    //  print('_________sucees insert___________');
    Get.back();

    setState(() {
      processing = false;
    });
  }
}
