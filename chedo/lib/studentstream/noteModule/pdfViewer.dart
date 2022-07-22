// ignore_for_file: avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  String pdfUrl, title;
  PDFViewer(this.title, this.pdfUrl, {Key? key}) : super(key: key);

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  bool processing = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
      ),
      body: SafeArea(
          child: Center(
              child: SfPdfViewer.network(
        widget.pdfUrl,
        pageLayoutMode: PdfPageLayoutMode.single,
        enableDoubleTapZooming: true,
        onDocumentLoaded: (a) {
          setState(() {
            processing = false;
          });
          print('________________load_________________');
        },
        onDocumentLoadFailed: (a) {
          Get.back();
          Get.snackbar('Error', 'Invalid PDF file ' + a.description);
        },
      ))),
    );
  }
}
