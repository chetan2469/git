import 'package:flutter/material.dart';

class NumberVerification extends StatefulWidget {
  @override
  _NumberVerificationState createState() => _NumberVerificationState();
}

class _NumberVerificationState extends State<NumberVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: SafeArea(
          child: Stack(
            children: <Widget>[
              DecoratedBox(
        decoration: BoxDecoration(
            //color: Color(0xff7c94b6),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.hardLight),
                image: AssetImage(
                  'assets/wallpaper.jpg',
                ),
                fit: BoxFit.cover)),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: 300),
            alignment: Alignment.center,
            child: ListView(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(10),
                    child: DecoratedBox(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                           // labelText: 'Add Mobile No.',
                            hintText: 'Add Mobile No',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.6)),
                    )),
                Container(
                    margin: EdgeInsets.all(10),
                    child: DecoratedBox(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: 'Verify OTP',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.6)),
                    )),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Container(
                    margin: EdgeInsets.only(top: 40, left: 50, right: 50),
                    child: RaisedButton(
                      color: Colors.white.withOpacity(0.6),
                      child: Text(
                        "Send OTP",
                        style: TextStyle(fontSize: 15),
                      ),
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
            ],
          ),
          
        ),
    );
  }
}
