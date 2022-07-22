import 'package:flutter/material.dart';
import 'package:chedo/data/receiptEntry.dart';

class EditReceipt extends StatefulWidget {
  final ReceiptEntry receiptEntry;

  const EditReceipt(this.receiptEntry, {Key? key}) : super(key: key);

  @override
  _EditReceiptState createState() => _EditReceiptState();
}

class _EditReceiptState extends State<EditReceipt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.receiptEntry.paying_amount.toString()),
      ),
    );
  }
}
