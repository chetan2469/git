import 'package:cloud_firestore/cloud_firestore.dart';

class CourseRecord {
  final String name, duration, fees, syllabus, teacher, note, imageUrl, addedBy;
  Timestamp addDate;
  DocumentReference reference;

  CourseRecord(this.name, this.addDate, this.addedBy, this.duration, this.fees,
      this.imageUrl, this.note, this.reference, this.syllabus, this.teacher);
}




// CourseRecord.fromMap(Map<String, dynamic> map, {required this.reference})
  //     : assert(map['name'] != null),
  //       assert(map['duration'] != null),
  //       assert(map['fees'] != null),
  //       assert(map['syllabus'] != null),
  //       assert(map['teacher'] != null),
  //       assert(map['note'] != null),
  //       assert(map['imageUrl'] != null),
  //       assert(map['addDate'] != null),
  //       assert(map['addedBy'] != null),
  //       name = map['name'],
  //       duration = map['duration'],
  //       fees = map['fees'],
  //       syllabus = map['syllabus'],
  //       teacher = map['teacher'],
  //       note = map['note'],
  //       addedBy = map['addedBy'],
  //       addDate = map['addDate'],
  //       imageUrl = map['imageUrl'];