// // ignore_for_file: avoid_unnecessary_containers, avoid_print, prefer_is_empty

// import 'dart:async';
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class ParseMcq extends StatefulWidget {
//   const ParseMcq({Key? key}) : super(key: key);

//   @override
//   _ParseMcqState createState() => _ParseMcqState();
// }

// class _ParseMcqState extends State<ParseMcq> {
//   List<MCQData> mcq = [];

//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   Future<void> insert() async {
//     for (var item in mcq) {
//       await firestore.collection('mcqData').doc().set({
//         'subject': item.subject,
//         'question': encode(item.question),
//         'option1': encode(item.op1),
//         'option2': encode(item.op2),
//         'option3': encode(item.op3),
//         'option4': encode(item.op4),
//         'solution': encode(item.solution),
//         'ans': getAnsInt(item.ans),
//         'addedBy': item.addedBy,
//         'verified': false,
//         'addedDate': DateTime.now(),
//       });
//     }
//   }

//   Future<void> getList(http.Client client) async {
//     final response = await client.get(Uri.parse(
//         'https://raw.githubusercontent.com/chetan2469/instituteManagement/master/javaMCQ'));

//     setState(() {
//       mcq = (json.decode(response.body) as List)
//           .map((data) => MCQData.fromJson(data))
//           .toList();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getList(http.Client());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           floatingActionButton: FloatingActionButton(onPressed: () async {
//             await insert();
//             print('Data Inserted....');
//           }),
//           body: mcq.length < 0
//               ? const CircularProgressIndicator()
//               : ListView.builder(
//                   itemCount: mcq.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       child: Text((mcq[index].question)),
//                     );
//                   })),
//     );
//   }

//   int getAnsInt(str) {
//     if (str == "A") {
//       return 1;
//     } else if (str == "B") {
//       return 2;
//     } else if (str == "C") {
//       return 3;
//     } else if (str == "D") {
//       return 4;
//     } else {
//       return 0;
//     }
//   }

//   String encode(String value) {
//     return value.codeUnits
//         .map((v) => v.toRadixString(2).padLeft(8, '0'))
//         .join(" ");
//   }
// }

// class MCQData {
//   final String question, op1, op2, op3, op4, subject, addedBy, solution, ans;
//   bool isExpanded = false;
//   Timestamp addedDate;
//   bool isVarified;

//   MCQData(
//       {required this.subject,
//       required this.question,
//       required this.op1,
//       required this.op2,
//       required this.op3,
//       required this.op4,
//       required this.ans,
//       required this.solution,
//       required this.addedBy,
//       required this.isVarified,
//       required this.addedDate});

//   factory MCQData.fromJson(Map<String, dynamic> json) {
//     return MCQData(
//       ans: json['ans'],
//       question: json['question'] as String,
//       op1: json['option1'] as String,
//       op2: json['option2'] as String,
//       op3: json['option3'] as String,
//       op4: json['option4'] as String,
//       subject: 'Java',
//       solution: '',
//       addedBy: 'chedotech@gmail.com',
//       addedDate: Timestamp.now(),
//       isVarified: false,
//     );
//   }
// }
