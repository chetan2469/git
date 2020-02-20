import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClientView extends StatefulWidget {
  @override
  _ClientViewState createState() => _ClientViewState();
}

class _ClientViewState extends State<ClientView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: Icon(
          FontAwesomeIcons.alignLeft,
          color: Colors.black,
        ),
        actions: <Widget>[
          Icon(
            Icons.search,
            color: Colors.black,
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.notifications_none,
            color: Colors.black,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 160,
            width: 160,
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 4,
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: Container(
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.all(20),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset('assets/people.png')),
                              )),
                          Expanded(
                            flex: 5,
                            child: Container(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Monika S. ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                          color: Colors.red,
                                        )),
                                    TextSpan(
                                        text: ' #342562',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w200)),
                                    TextSpan(
                                        text: '\nSoftware Eng - Graduate',
                                        style: TextStyle(
                                           fontWeight: FontWeight.w300
                                        )),
                                    TextSpan(
                                        text: '\n29 years , 5ft 11in',
                                        style: TextStyle( fontWeight: FontWeight.w300)),
                                    TextSpan(
                                        text: '\nHindu , Delhi , India',
                                        style: TextStyle(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                  margin: EdgeInsets.only(top: 16),
                                  alignment: Alignment.topCenter,
                                  child: Icon(
                                    
                                    FontAwesomeIcons.ellipsisH,
                                    size: 25,
                                  )))
                        ],
                      ),
                    )),
                SizedBox(
                  height: 2,
                ),

                //  !!!!!!!!!!!!!!!!     Row
                Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 2,
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.redAccent,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Icon(
                                        Icons.favorite_border,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.redAccent,
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Icon(
                                        FontAwesomeIcons.comment,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.redAccent, width: 2),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.red),
                              child: Center(
                                  child: Text(
                                "Send Interest",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              )),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}