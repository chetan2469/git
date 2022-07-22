import 'package:chedo/data/mcqData.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class QuestionView extends StatefulWidget {
  List<MCQData> filteredMcqDataList;
  int i;
  String subjectName;
  QuestionView(this.filteredMcqDataList, this.i, this.subjectName, {Key? key})
      : super(key: key);

  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
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
    return DelayedDisplay(
      fadeIn: true,
      delay: const Duration(milliseconds: 1),
      child: Scaffold(
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
                    widget.subjectName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    ('MCQ Question'),
                    style: TextStyle(fontSize: 10),
                  ),
                  trailing: Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(
                      (widget.i.toString()),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex:
                  decode(widget.filteredMcqDataList[widget.i].question).length <
                          100
                      ? 2
                      : 4,
              child: Container(
                color: Colors.black,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Expanded(
                          child: Container(
                              padding: const EdgeInsets.only(top: 10),
                              alignment: Alignment.topCenter,
                              color: Colors.black87,
                              child: const Icon(
                                Icons.question_answer,
                                color: Colors.white,
                              )),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topCenter,
                            color: Colors.black87,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.i--;
                                  });
                                  if (widget.i < 0) {
                                    Get.back();
                                  }
                                  initialisecolorset();
                                },
                                icon: const Icon(
                                  Icons.arrow_left,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    )),
                    Expanded(
                      flex: 12,
                      child: Container(
                        color: Colors.black87,
                        child: ListTile(
                          title: Text(
                              decode(widget
                                  .filteredMcqDataList[widget.i].question),
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.only(top: 30),
                      alignment: Alignment.centerLeft,
                      color: Colors.black87,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.i++;
                            });
                            if (widget.i >= widget.filteredMcqDataList.length) {
                              Get.back();
                            }

                            initialisecolorset();
                          },
                          icon: const Icon(
                            Icons.arrow_right,
                            color: Colors.white,
                          )),
                    )),
                  ],
                ),
              ),
            ),
            Expanded(
              flex:
                  decode(widget.filteredMcqDataList[widget.i].question).length <
                          100
                      ? 6
                      : 4,
              child: Container(
                color: Colors.black,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          op1Color =
                              widget.filteredMcqDataList[widget.i].ans == 1
                                  ? ansStyle
                                  : wrongColor;
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 20),
                        title: Text(
                          decode(widget.filteredMcqDataList[widget.i].op1),
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
                          op2Color =
                              widget.filteredMcqDataList[widget.i].ans == 2
                                  ? ansStyle
                                  : wrongColor;
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 20),
                        title: Text(
                          decode(widget.filteredMcqDataList[widget.i].op2),
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
                          op3Color =
                              widget.filteredMcqDataList[widget.i].ans == 3
                                  ? ansStyle
                                  : wrongColor;
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 20),
                        title: Text(
                          decode(widget.filteredMcqDataList[widget.i].op3),
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
                          op4Color =
                              widget.filteredMcqDataList[widget.i].ans == 4
                                  ? ansStyle
                                  : wrongColor;
                        });
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 20),
                        title: Text(
                          decode(widget.filteredMcqDataList[widget.i].op4),
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
      ),
    );
  }

  String decode(String value) {
    if (value.isNotEmpty) {
      return String.fromCharCodes(
          value.split(" ").map((v) => int.parse(v, radix: 2)));
    } else {
      return 'no more data found...';
    }
  }

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
