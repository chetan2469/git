import 'package:cloud_firestore/cloud_firestore.dart';

class MCQData {
  final String question, op1, op2, op3, op4, subject, addedBy, solution;
  int ans;
  bool isExpanded = false;
  Timestamp addedDate;
  bool isVarified;
  DocumentReference reference;

  MCQData(
      {required this.subject,
      required this.question,
      required this.op1,
      required this.op2,
      required this.op3,
      required this.op4,
      required this.ans,
      required this.solution,
      required this.addedBy,
      required this.isVarified,
      required this.addedDate,
      required this.reference});

  // factory MCQData.fromJson(Map<String, dynamic> json) {
  //   return MCQData(
  //     ans: json['ans'] as String,
  //     question: json['question'] as String,
  //     op1: json['option1'] as String,
  //     op2: json['option2'] as String,
  //     op3: json['option3'] as String,
  //     op4: json['option4'] as String,
  //     subject: 'C Programming',
  //     solution: '',
  //     addedBy: 'chedotech@gmail.com',
  //     addedDate: Timestamp.now(),
  //     isVarified: false,
  //   );
  // }
}
