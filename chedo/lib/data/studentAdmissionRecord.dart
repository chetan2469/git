import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAdmissionRecord {
  List courses;
  List receipts = [];
  String name,
      address,
      mobileno,
      optionalno,
      aadharno,
      pursuing_course,
      batchtime,
      studentMail = '',
      imageurl;
  int outStandingAmount;
  bool isEditor = false;
  Timestamp dateofbirth, addDate;
  bool status;
  DocumentReference reference;

  StudentAdmissionRecord(
      {required this.aadharno,
      required this.addDate,
      // required this.receipts,
      required this.address,
      required this.batchtime,
      required this.courses,
      required this.dateofbirth,
      required this.imageurl,
      required this.mobileno,
      required this.name,
      required this.optionalno,
      required this.outStandingAmount,
      required this.pursuing_course,
      required this.reference,
      required this.status});
}
