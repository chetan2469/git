// ignore_for_file: use_key_in_widget_constructors, avoid_print, unnecessary_null_comparison

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:chedo/data/studentCourseEntry.dart';

class AddReceipt extends StatefulWidget {
  final DateTime date;
  final DocumentReference studentReference;
  final Function updateOutStandingAmount;
  final Function updateReceiptList;
  final int outStandingAmount;
  final List<StudentCourseEntry> selectedStudentCoursesList;

  const AddReceipt(
      this.selectedStudentCoursesList,
      this.date,
      this.studentReference,
      this.outStandingAmount,
      this.updateOutStandingAmount,
      this.updateReceiptList);

  @override
  _AddReceiptState createState() => _AddReceiptState();
}

class _AddReceiptState extends State<AddReceipt> {
  bool processing = false, status = true, editing = false;
  // ignore: non_constant_identifier_names
  late DateTime receipt_date, next_installment_date;
  late StudentCourseEntry selectedCourse;
  late int outStandingAmount, payingFees;
  late String paymentMethod, receiptNumberFromBook, note;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> paymentMethodsList = [
    'Cash',
    'Gpay',
    'Paytm',
    'Phonepay',
    'Online',
    'Card',
    'Other'
  ]; // Option 2
  TextEditingController totalCourseFeesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      paymentMethod = "Cash";
      selectedCourse = widget.selectedStudentCoursesList.last;
      receipt_date = widget.date;
      outStandingAmount = widget.outStandingAmount;
    });
  }

  void insert() async {
    setState(() {
      processing = true;
    });
    DocumentReference referenceId = firestore.collection('receipts').doc();
    await referenceId.set({
      'course_name': selectedCourse.course_name,
      'paying_amount': payingFees,
      'course_id': selectedCourse.reference,
      'receipt_date': receipt_date,
      'next_installment_date': next_installment_date,
      'payment_method': paymentMethod,
      'receipt_page_number': receiptNumberFromBook,
      'student_id': widget.studentReference,
      'note': note,
    });

    // ReceiptEntry receiptEntry = ReceiptEntry(payingFees, paymentMethod,
    //     selectedCourse.reference.id, widget.studentReference.id, referenceId);

    // widget.updateReceiptList(receiptEntry);

    setState(() {
      processing = false;
    });
    // widget.updateCourseList(studentCourseEntry);
    print(" Added Entry at " + referenceId.id);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Course"),
        actions: <Widget>[
          InkWell(
            onTap: () {
              if (selectedCourse != null && receipt_date != null) {
                insert();
              }
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              child: const Icon(Icons.save),
            ),
          )
        ],
      ),
      body: Center(
        child: processing
            ? const CircularProgressIndicator()
            : ListView(
                children: <Widget>[
                  selectedCourse != null
                      ? ListTile(
                          leading: Container(
                              margin: const EdgeInsets.all(20),
                              child: const Text('Receipt Number on book')),
                          title: Container(
                            margin: const EdgeInsets.all(20),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '101'),
                              onChanged: (str) {
                                setState(() {
                                  receiptNumberFromBook = str;
                                });
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),
                  ListTile(
                    leading: Container(
                        margin: const EdgeInsets.all(20),
                        child: const Text("Choose Course ")),
                    title: DropdownButton<StudentCourseEntry>(
                      onChanged: (v) {},
                      hint: const Text("Select item"),
                      value: selectedCourse,
                      // onChanged: (StudentCourseEntry Value) {
                      //   setState(() {
                      //     selectedCourse = Value;
                      //     print(selectedCourse.course_name);
                      //   });
                      // },
                      items: widget.selectedStudentCoursesList
                          .map((StudentCourseEntry user) {
                        return DropdownMenuItem<StudentCourseEntry>(
                          value: user,
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.book),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                user.course_name,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  selectedCourse != null
                      ? ListTile(
                          leading: Container(
                              margin: const EdgeInsets.all(20),
                              child: const Text('Payment Method')),
                          title: DropdownButton(
                            // Not necessary for Option 1
                            value: paymentMethod,
                            onChanged: (newValue) {
                              setState(() {
                                paymentMethod = newValue.toString();
                              });
                              print(paymentMethod);
                            },
                            items: paymentMethodsList.map((paymentMethod) {
                              return DropdownMenuItem(
                                child: Text(paymentMethod),
                                value: paymentMethod,
                              );
                            }).toList(),
                          ),
                        )
                      : const SizedBox(),
                  selectedCourse != null
                      ? ListTile(
                          leading: Container(
                              margin: const EdgeInsets.all(20),
                              child: const Text('Paying Fees')),
                          title: Container(
                            margin: const EdgeInsets.all(20),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Paying Fees'),
                              onChanged: (String value) {
                                setState(() {
                                  payingFees = int.parse(value);
                                  outStandingAmount = widget.outStandingAmount -
                                      int.parse(value);
                                });
                              },
                            ),
                          ),
                        )
                      : const SizedBox(),
                  selectedCourse != null
                      ? ListTile(
                          leading: Container(
                              margin: const EdgeInsets.all(20),
                              child: const Text('Outstanding Fees')),
                          title: Container(
                            margin: const EdgeInsets.all(20),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  hintText: outStandingAmount.toString()),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  selectedCourse != null
                      ? Container(
                          margin: const EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(2017, 1, 1),
                                  maxTime: DateTime.now()
                                      .add(const Duration(days: 365)),
                                  onChanged: (date) {
                                print('change $date');
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: ListTile(
                              leading: const Text("Receipt Date    "),
                              trailing: const Icon(Icons.calendar_today),
                              title: receipt_date != null
                                  ? Container(
                                      color: Colors.redAccent,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                          receipt_date.day.toString() +
                                              ' / ' +
                                              receipt_date.month.toString() +
                                              ' / ' +
                                              receipt_date.year.toString(),
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    )
                                  : Container(
                                      color: Colors.redAccent,
                                      padding: const EdgeInsets.all(10),
                                      child: const Text(
                                        "Select Date",
                                        style: TextStyle(color: Colors.white),
                                      )),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  selectedCourse != null
                      ? Container(
                          margin: const EdgeInsets.all(20),
                          child: InkWell(
                            onTap: () {
                              DatePicker.showDatePicker(context,
                                  showTitleActions: true,
                                  minTime: DateTime(1960, 1, 1),
                                  maxTime: DateTime.now()
                                      .add(const Duration(days: 730)),
                                  onChanged: (date) {
                                print('change $date');
                              }, onConfirm: (date) {
                                print('confirm $date');
                                setState(() {
                                  next_installment_date = date;
                                });
                              },
                                  currentTime: DateTime.now(),
                                  locale: LocaleType.en);
                            },
                            child: ListTile(
                              leading: const Text(' Next Installment'),
                              trailing: const Icon(Icons.calendar_today),
                              title: next_installment_date != null
                                  ? Container(
                                      color: Colors.redAccent,
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                          next_installment_date.day.toString() +
                                              ' / ' +
                                              next_installment_date.month
                                                  .toString() +
                                              ' / ' +
                                              next_installment_date.year
                                                  .toString(),
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    )
                                  : Container(
                                      color: Colors.redAccent,
                                      padding: const EdgeInsets.all(10),
                                      child: const Text(
                                        "Select Date",
                                        style: TextStyle(color: Colors.white),
                                      )),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: TextField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Write some note...'),
                      onChanged: (str) {
                        setState(() {
                          note = str;
                        });
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
