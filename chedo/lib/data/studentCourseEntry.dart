// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class StudentCourseEntry {
  final String course_name;
  final String course_total_fees, course_fees;
  Timestamp course_start_date, course_validity_date;
  final DocumentReference reference;

  StudentCourseEntry(
      {required this.course_name,
      required this.course_fees,
      required this.course_start_date,
      required this.course_total_fees,
      required this.course_validity_date,
      required this.reference});

  StudentCourseEntry.fromMap(Map<String, dynamic> map,
      {required this.reference})
      : assert(map['course_name'] != null),
        assert(map['course_total_fees'] != null),
        assert(map['course_fees'] != null),
        assert(map['course_start_date'] != null),
        assert(map['course_validity_date'] != null),
        course_name = map['course_name'],
        course_total_fees = map['course_total_fees'],
        course_fees = map['course_remaining_fees'],
        course_start_date = map['course_start_date'],
        course_validity_date = map['course_validity_date'];
}
