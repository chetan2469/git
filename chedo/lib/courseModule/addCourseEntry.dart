import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:chedo/data/course_record.dart';
import 'package:chedo/data/studentCourseEntry.dart';

class AddCourseEntry extends StatefulWidget {
  final DateTime date;
  final Function updateCourseList;

  const AddCourseEntry(this.updateCourseList, this.date);

  @override
  _AddCourseEntryState createState() => _AddCourseEntryState();
}

class _AddCourseEntryState extends State<AddCourseEntry> {
  bool processing = false, status = true, editing = false;
  // ignore: non_constant_identifier_names
  late DateTime course_start_date, course_validity_date = DateTime.now();
  List courses = [];
  List<CourseRecord> courseList = [];
  late CourseRecord selectedCourse;

  TextEditingController totalCourseFeesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCourseData();

    setState(() {
      course_start_date = widget.date;
    });
    //  setDefaultSelectedCourse();
  }

  fetchCourseData() async {
    setState(() {
      processing = true;
      courseList.clear();
    });
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('courses').get();

    final List<DocumentSnapshot> documents = result.docs;

    for (var ds in documents) {
      final record = CourseRecord(
          (ds as dynamic)['name'],
          (ds as dynamic)['addDate'],
          (ds as dynamic)['addedBy'],
          (ds as dynamic)['duration'],
          (ds as dynamic)['fees'],
          (ds as dynamic)['imageUrl'],
          (ds as dynamic)['note'],
          ds.reference,
          (ds as dynamic)['syllabus'],
          (ds as dynamic)['teacher']);
      courseList.add(record);
    }

    setState(() {
      processing = false;
      selectedCourse = courseList[0];
    });

    //  print(courseList);
  }

  void insert() async {
    setState(() {
      processing = true;
    });
    DocumentReference referenceId =
        FirebaseFirestore.instance.collection('student_course').doc();
    await referenceId.set({
      'course_name': selectedCourse.name,
      'course_fees': selectedCourse.fees,
      'course_total_fees': totalCourseFeesController.text,
      'course_start_date': course_start_date,
      'course_validity_date': course_validity_date,
    });
    StudentCourseEntry studentCourseEntry = StudentCourseEntry(
        course_name: selectedCourse.name,
        course_fees: totalCourseFeesController.text,
        course_start_date: Timestamp.now(),
        course_total_fees: totalCourseFeesController.text,
        course_validity_date: Timestamp.now(),
        reference: referenceId);

    setState(() {
      processing = false;
    });
    widget.updateCourseList(studentCourseEntry);
    //  print(" Add Entry Page course doc  " + referenceId.id);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Course"),
        actions: <Widget>[
          InkWell(
            onTap: () {
              if (selectedCourse != null && course_start_date != null) {
                insert();
              }
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              child: const Icon(Icons.save),
            ),
          )
        ],
      ),
      body: Center(
        child: processing
            ? const CircularProgressIndicator()
            : ListView(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(20),
                    height: 200,
                    child: Image.network(selectedCourse.imageUrl),
                  ),
                  ListTile(
                    leading: Container(
                        margin: const EdgeInsets.all(20),
                        child: const Text("Choose Course ")),
                    title: DropdownButton<CourseRecord>(
                      hint: const Text("Select item"),
                      value: selectedCourse,
                      onChanged: (val) {
                        setState(() {
                          selectedCourse = val!;
                          //  print(selectedCourse.name);
                          //  print(selectedCourse.fees);
                          totalCourseFeesController.text =
                              selectedCourse.fees.toString();
                          if (course_start_date != null) {
                            course_validity_date = course_start_date.add(
                                Duration(
                                    days: int.parse(selectedCourse.duration) *
                                        2));
                          }
                        });
                      },
                      items: courseList.map((CourseRecord user) {
                        return DropdownMenuItem<CourseRecord>(
                          value: user,
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.book),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                user.name,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  selectedCourse != null
                      ? ListTile(
                          leading: Container(
                              margin: const EdgeInsets.all(20),
                              child: const Text('Course Fees')),
                          title: Container(
                            margin: const EdgeInsets.all(20),
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: selectedCourse == null
                                      ? 'Course Fees'
                                      : selectedCourse.fees.toString()),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  selectedCourse != null
                      ? ListTile(
                          leading: Container(
                            margin: const EdgeInsets.all(20),
                            child: const Text("Total Fees   "),
                          ),
                          title: Container(
                            margin: const EdgeInsets.all(20),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: totalCourseFeesController,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: selectedCourse == null
                                      ? 'Total Course Fees'
                                      : selectedCourse.fees.toString()),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  selectedCourse != null
                      ? Container(
                          margin: const EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(1960, 1, 1),
                                  maxTime: DateTime.now()
                                      .add(const Duration(days: 365)),
                                  onChanged: (date) {
                                //  print('change $date');
                              }, onConfirm: (date) {
                                //  print('confirm $date');
                                setState(() {
                                  course_start_date = date;
                                  course_validity_date = course_start_date.add(
                                      Duration(
                                          days: int.parse(
                                                  selectedCourse.duration) *
                                              2));
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: ListTile(
                              leading: const Text("Course Start Date    "),
                              trailing: const Icon(Icons.calendar_today),
                              title: course_start_date != null
                                  ? Container(
                                      color: Colors.redAccent,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                          course_start_date.day.toString() +
                                              ' / ' +
                                              course_start_date.month
                                                  .toString() +
                                              ' / ' +
                                              course_start_date.year.toString(),
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    )
                                  : Container(
                                      color: Colors.redAccent,
                                      padding: const EdgeInsets.all(10),
                                      child: const Text(
                                        "Select Date",
                                        style: TextStyle(color: Colors.white),
                                      )),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  selectedCourse != null
                      ? Container(
                          margin: const EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(1960, 1, 1),
                                  maxTime: DateTime.now()
                                      .add(const Duration(days: 730)),
                                  onChanged: (date) {
                                //  print('change $date');
                              }, onConfirm: (date) {
                                //  print('confirm $date');
                                setState(() {
                                  course_validity_date = date;
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: ListTile(
                              leading: const Text(' Course Validity Date'),
                              trailing: const Icon(Icons.calendar_today),
                              title: course_validity_date != null
                                  ? Container(
                                      color: Colors.redAccent,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                          course_validity_date.day.toString() +
                                              ' / ' +
                                              course_validity_date.month
                                                  .toString() +
                                              ' / ' +
                                              course_validity_date.year
                                                  .toString(),
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    )
                                  : Container(
                                      color: Colors.redAccent,
                                      padding: const EdgeInsets.all(10),
                                      child: const Text(
                                        "Select Date",
                                        style: TextStyle(color: Colors.white),
                                      )),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
      ),
    );
  }
}
