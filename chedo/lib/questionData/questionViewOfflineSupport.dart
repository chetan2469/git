import 'package:chedo/data/mcqData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class QuestionViewOfflineSupport extends StatefulWidget {
  MCQData mcq;
  int loc;
  QuestionViewOfflineSupport({Key? key, required this.mcq, required this.loc})
      : super(key: key);

  @override
  _QuestionViewOfflineSupportState createState() =>
      _QuestionViewOfflineSupportState();
}

class _QuestionViewOfflineSupportState
    extends State<QuestionViewOfflineSupport> {
  TextStyle wrongColor = const TextStyle(color: Colors.red);
  TextStyle ansStyle = const TextStyle(color: Colors.green);
  TextStyle op1Color = const TextStyle(color: Colors.white);
  TextStyle op2Color = const TextStyle(color: Colors.white);
  TextStyle op3Color = const TextStyle(color: Colors.white);
  TextStyle op4Color = const TextStyle(color: Colors.white);
  Color dividerColor = Colors.white38;

  @override
  void initState() {
    super.initState();
    initialisecolorset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
              )),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(Icons.arrow_back)),
                title: Text(
                  widget.mcq.subject,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  ('MCQ Question'),
                  style: TextStyle(fontSize: 10),
                ),
                trailing: Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    (widget.loc + 1).toString(),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: widget.mcq.question.length < 100 ? 2 : 4,
            child: Container(
              color: Colors.black,
              child: Container(
                color: Colors.black87,
                child: ListTile(
                  title: Text(widget.mcq.question,
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
          Expanded(
            flex: widget.mcq.question.length < 100 ? 6 : 4,
            child: Container(
              color: Colors.black,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        op1Color = widget.mcq.ans == 1 ? ansStyle : wrongColor;
                      });
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 20),
                      title: Text(
                        widget.mcq.op1,
                        style: op1Color,
                      ),
                    ),
                  ),
                  Divider(
                    color: dividerColor,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        op2Color = widget.mcq.ans == 2 ? ansStyle : wrongColor;
                      });
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 20),
                      title: Text(
                        widget.mcq.op2,
                        style: op2Color,
                      ),
                    ),
                  ),
                  Divider(
                    color: dividerColor,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        op3Color = widget.mcq.ans == 3 ? ansStyle : wrongColor;
                      });
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 20),
                      title: Text(
                        widget.mcq.op3,
                        style: op3Color,
                      ),
                    ),
                  ),
                  Divider(
                    color: dividerColor,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        op4Color = widget.mcq.ans == 4 ? ansStyle : wrongColor;
                      });
                    },
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(left: 20),
                      title: Text(
                        widget.mcq.op4,
                        style: op4Color,
                      ),
                    ),
                  ),
                  Divider(
                    color: dividerColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // String decode(String value) {
  //   if (value.length > 0) {
  //     return String.fromCharCodes(
  //         value.split(" ").map((v) => int.parse(v, radix: 2)));
  //   } else {
  //     return 'no more data found...';
  //   }
  // }

  void initialisecolorset() {
    setState(() {
      wrongColor = const TextStyle(color: Colors.red);
      ansStyle = const TextStyle(color: Colors.green);
      op1Color = const TextStyle(color: Colors.white);
      op2Color = const TextStyle(color: Colors.white);
      op3Color = const TextStyle(color: Colors.white);
      op4Color = const TextStyle(color: Colors.white);
      dividerColor = Colors.white38;
    });
  }
}
