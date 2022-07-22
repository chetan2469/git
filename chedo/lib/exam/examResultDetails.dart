// ignore_for_file: file_names

import 'package:chedo/data/mcqData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExamResult extends StatefulWidget {
  List<MCQData> selectedMcqForExam;
  List<int> radioAnswers;
  int marks;
  ExamResult(this.selectedMcqForExam, this.radioAnswers, this.marks, {Key? key})
      : super(key: key);

  @override
  _ExamResultState createState() =>
      // ignore: unnecessary_this, no_logic_in_create_state
      _ExamResultState(selectedMcqForExam, radioAnswers, this.marks);
}

class _ExamResultState extends State<ExamResult> {
  List<MCQData> selectedMcqForExam;
  List<int> radioAnswers;
  int marks;
  _ExamResultState(this.selectedMcqForExam, this.radioAnswers, this.marks);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Result : " + '$marks/20'),
        ),
        body: ListView.builder(
          itemCount: selectedMcqForExam.length,
          itemBuilder: (BuildContext cotext, int i) {
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    color: Colors.blueGrey[50],
                    child: ListTile(
                      leading: const Icon(Icons.question_answer),
                      title: Text(selectedMcqForExam[i].question,
                          style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: radioAnswers[i] == 1
                                ? getAnsColor(i, 1)
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                        color: selectedMcqForExam[i].ans == 1
                            ? Colors.green[50]
                            : Colors.transparent),
                    margin: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    child: Text(selectedMcqForExam[i].op1,
                        style: const TextStyle(fontSize: 12)),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: radioAnswers[i] == 2
                                ? getAnsColor(i, 2)
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                        color: selectedMcqForExam[i].ans == 2
                            ? Colors.green[50]
                            : Colors.transparent),
                    margin: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    child: Text(selectedMcqForExam[i].op2,
                        style: const TextStyle(fontSize: 12)),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: radioAnswers[i] == 3
                                ? getAnsColor(i, 3)
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                        color: selectedMcqForExam[i].ans == 3
                            ? Colors.green[50]
                            : Colors.transparent),
                    margin: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    child: Text(selectedMcqForExam[i].op3,
                        style: const TextStyle(fontSize: 12)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: radioAnswers[i] == 4
                                ? getAnsColor(i, 4)
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(10),
                        color: selectedMcqForExam[i].ans == 4
                            ? Colors.green[50]
                            : Colors.transparent),
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    child: Text(selectedMcqForExam[i].op4,
                        style: const TextStyle(fontSize: 12)),
                  ),
                  const Divider(),
                  ListTile(
                      title: Text(
                    "Explanation : " + selectedMcqForExam[i].solution,
                    style: const TextStyle(fontSize: 10),
                  )),
                  const Divider(),
                  const Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color getAnsColor(int i, int op) {
    if (radioAnswers[i] != selectedMcqForExam[i].ans) {
      return Colors.red;
    }
    return Colors.transparent;
  }
}
