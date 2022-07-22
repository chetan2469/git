import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StreamBuilderDemo extends StatefulWidget {
  const StreamBuilderDemo({Key? key}) : super(key: key);

  @override
  _StreamBuilderDemoState createState() => _StreamBuilderDemoState();
}

class _StreamBuilderDemoState extends State<StreamBuilderDemo> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('mcqData').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.requireData;
            return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                return Text(
                  data.docs[index]['solution'],
                );
              },
            );
          }),
    );
  }
}
