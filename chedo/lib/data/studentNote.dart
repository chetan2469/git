import 'package:cloud_firestore/cloud_firestore.dart';

class StudentNote {
  final String chapter, fileUrl, subject;
  Timestamp uploadTime;
  bool deletedByStudent;
  DocumentReference reference;

  StudentNote(
      {required this.chapter,
      required this.fileUrl,
      required this.subject,
      required this.uploadTime,
      required this.deletedByStudent,
      required this.reference});
}
