import 'package:cloud_firestore/cloud_firestore.dart';

class EnquiryRecord {
  String name, mobile, enqFrom, enqFor, note;
  Timestamp enqDate, prefTime;
  List followUpNotes;
  DocumentReference reference;

  EnquiryRecord(this.name, this.mobile, this.enqFrom, this.enqFor, this.note,
      this.enqDate, this.prefTime, this.followUpNotes, this.reference);
}
