//import 'package:chedoinstitute/data/course_record.dart';
// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

//import 'enquiryFrom.dart';

class EnquiryPage extends StatefulWidget {
  const EnquiryPage({Key? key}) : super(key: key);

  //final List<EnquiryFromOption> enqFromList;

  // EnquiryPage({required this.enqFromList});

  @override
  _EnquiryPageState createState() => _EnquiryPageState();
}

class _EnquiryPageState extends State<EnquiryPage> {
  // late EnquiryFromOption _chosenValue;
  // List<CourseRecord> courseList = [];
  List<String> efoList = ['Google', 'Facebook'];
  List<String> cList = ['c', 'cpp', 'java'];
  bool processing = false;
  DateTime selectedDate = DateTime.now();
  DateTime prefTime = DateTime.now();
  int efoListselectedLoc = 0, courseListselectedLoc = 0;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    // fetchCourseData();
    // setState(() {
    //   for (var i in widget.enqFromList) {
    //     efoList.add(i.name);
    //   }
    // });
    super.initState();
  }

  Widget efoListselectedLocDrop() {
    return DropdownButton(
        isExpanded: true,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
        value: efoList[efoListselectedLoc],
        hint: const Text("Choose Option"),
        items: efoList.map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Row(
              children: <Widget>[Text(value)],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            setState(() {
              efoListselectedLoc = efoList.indexOf(value.toString());
            });
            print(value);
          });
          //getTravelCity(value.name);
        });
  }

  Widget courseListselectedLocDrop() {
    return DropdownButton(
        menuMaxHeight: 400,
        isExpanded: true,
        style: const TextStyle(color: Colors.black45, fontSize: 12),
        value: cList[courseListselectedLoc],
        hint: const Text("Choose Option"),
        items: cList.map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Row(
              children: <Widget>[Text(value)],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            setState(() {
              courseListselectedLoc = cList.indexOf(value.toString());
            });
            print(value);
          });
          //getTravelCity(value.name);
        });
  }

  String mob = '';
  String name = '';
  String poc = '';
  String description = '';

  bool NameCheck = true;
  bool MobileCheck = true;
  bool NoteCheck = true;

  final maxlines = 7;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: processing
              ? const CircularProgressIndicator()
              : const Icon(
                  Icons.done,
                ),
          onPressed: () {
            if (isValidate()) {
              insert();
            }
          },
        ),
        body: processing
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                      child: ListTile(
                    leading: InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back)),
                    title: const Text(
                      'Add Enquiry',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.person),
                  )),
                  Expanded(
                    flex: 8,
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: TextField(
                            onChanged: (s) {
                              if (s.length > 5) {
                                setState(() {
                                  NameCheck = true;
                                });
                              } else {
                                setState(() {
                                  NameCheck = false;
                                });
                              }
                            },
                            maxLength: 25,
                            controller: nameController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                              ),

                              hintText: 'Name',
                              contentPadding: const EdgeInsets.all(18),
                              // labelText: 'Name',
                              // labelStyle: TextStyle(fontSize: 14),
                              errorText: NameCheck
                                  ? null
                                  : 'Must be greater than 5 Characters',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              prefixIcon: const Icon(
                                Icons.person,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: TextField(
                            onChanged: (s) {
                              if (s.length == 10) {
                                setState(() {
                                  MobileCheck = true;
                                });
                              } else {
                                setState(() {
                                  MobileCheck = false;
                                });
                              }
                            },
                            controller: mobileController,
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                              ),
                              hintText: 'Mobile Number',
                              errorText: MobileCheck
                                  ? null
                                  : 'Must be equal to 10 number',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              prefixIcon: const Icon(
                                Icons.call,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            height: 55,
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                                leading: const Icon(Icons.model_training_sharp),
                                title: efoListselectedLocDrop())),
                        Container(
                            height: 55,
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                                leading: const Icon(Icons.bolt_outlined),
                                title: courseListselectedLocDrop())),
                        InkWell(
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2017, 1, 1),
                                maxTime: DateTime.now(), onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              print('confirm $date');
                              setState(() {
                                selectedDate = date;
                              });
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            height: 55,
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: ListTile(
                              leading: const Icon(Icons.calendar_today),
                              title: Text(
                                selectedDate.day.toString() +
                                    ' / ' +
                                    selectedDate.month.toString() +
                                    ' / ' +
                                    selectedDate.year.toString() +
                                    ' \t\t ' +
                                    ' ( Enquiry Date )',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            DatePicker.showTime12hPicker(context,
                                showTitleActions: true, onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              print('confirm $date');
                              setState(() {
                                prefTime = date;
                              });
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            height: 55,
                            margin: const EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: ListTile(
                              leading: const Icon(Icons.access_time_sharp),
                              title: Text(
                                prefTime.hour.toString() +
                                    '  : ' +
                                    prefTime.month.toString() +
                                    ' \t\t ' +
                                    ' ( Preferable Time for course )',
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: TextField(
                            onChanged: (s) {
                              if (s.length > 5) {
                                setState(() {
                                  NoteCheck = true;
                                });
                              } else {
                                setState(() {
                                  NoteCheck = false;
                                });
                              }
                            },
                            controller: noteController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 2.0),
                              ),
                              hintText: 'Note',
                              errorText:
                                  NoteCheck ? null : 'Must be greater than 5',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              prefixIcon: const Icon(
                                Icons.note,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // fetchCourseData() async {
  //   setState(() {
  //     processing = true;
  //   });

  //   final QuerySnapshot result =
  //       await FirebaseFirestore.instance.collection('courses').get();

  //   final List<DocumentSnapshot> documents = result.docs;
  //   documents.forEach((data) {
  //     CourseRecord record = CourseRecord(
  //         (data as dynamic)['name'],
  //         (data as dynamic)['addDate'],
  //         (data as dynamic)['addedBy'],
  //         (data as dynamic)['duration'],
  //         (data as dynamic)['fees'],
  //         (data as dynamic)['imageUrl'],
  //         (data as dynamic)['note'],
  //         data.reference,
  //         (data as dynamic)['syllabus'],
  //         (data as dynamic)['teacher']);
  //     courseList.add(record);
  //   });

  //   setState(() {
  //     for (var i in courseList) {
  //       cList.add(i.name);
  //     }
  //     processing = false;
  //   });
  //   print(cList);
  // }

  void insert() async {
    setState(() {
      processing = true;
    });
    await firestore.collection('enquiryData').doc().set({
      'name': nameController.text,
      'mobileNo': mobileController.text,
      'enquiryFrom': efoList[efoListselectedLoc],
      'enquiryFor': cList[courseListselectedLoc],
      'enquiryDate': selectedDate,
      'prefTime': prefTime,
      'note': noteController.text
    });

    setState(() {
      processing = false;
    });

    // Navigator.pop(context);
    Get.back();
  }

  bool isValidate() {
    if (nameController.text.toString().length > 5 &&
        mobileController.text.toString().length == 10) {
      return true;
    }
    return false;
  }
}
