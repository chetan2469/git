import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:institute_management_system/demos/question.dart';

class FutureBuilderDemo extends StatefulWidget {
  @override
  _FutureBuilderDemoState createState() => _FutureBuilderDemoState();
}

class _FutureBuilderDemoState extends State<FutureBuilderDemo> {
  String url =
      'https://raw.githubusercontent.com/chetan2469/ccc_practice/master/data.json';
  String xml;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: url != null
                ? http.get(url).then((response) => response.body)
                : null,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text('Input a URL to start');
                case ConnectionState.waiting:
                  return new Center(child: new CircularProgressIndicator());
                case ConnectionState.active:
                  return new Text('');
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return new Text(
                      '${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return new ListView(
                        children: <Widget>[new Text(snapshot.data)]);
                  }
              }
            }),
      ),
    );
  }
  

  void fetch() async {
    List<Question> questions = new List();

    String link =
        "https://raw.githubusercontent.com/chetan2469/ccc_practice/master/data.json";

    final response = await http.get(link);
    if (response.statusCode == 200) {
      questions = (json.decode(response.body) as List)
          .map((data) => new Question.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load ');
    }
    print("______________" + questions.length.toString());
    for (var item in questions) {
      print(item.question);
    }
  }
}
