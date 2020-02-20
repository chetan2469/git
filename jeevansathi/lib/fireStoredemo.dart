import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FireStoreDemo extends StatefulWidget {
  @override
  _FireStoreDemoState createState() => _FireStoreDemoState();
}


class _FireStoreDemoState extends State<FireStoreDemo> {

TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            addEntry(),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    ));
  }

  Widget addEntry() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30),
            child: TextField(
              controller: nameController,
              decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  hintText: 'Tell us name of your friend',
                  helperText: 'Keep it short, this is just a name.',
                  labelText: 'Friend',
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                  prefixText: ' ',
                  suffixIcon: Icon(Icons.person),
                  suffixStyle: const TextStyle(color: Colors.green)),
            ),
          ),
          Container(
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){

              },
              
            ),
          )
        ],
      ),
    );
  }
}
