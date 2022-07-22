// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class FollowUpMessage {
  String msg;
  Timestamp time;
  String reference;
  FollowUpMessage(
      {required this.msg, required this.time, required this.reference});
}
