import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'constant.dart';
import 'customerList.dart';
import 'demo/menuIcons.dart';
import 'listOfItemPage.dart';
import 'orderPage.dart';

class DashBoardPage extends StatefulWidget {
  // final Function handleSignOut;
  // final GoogleSignInAccount _currentUser;
  // DashBoardPage(this.handleSignOut,this._currentUser);
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  FirebaseUser user;
  // String photoUrl = "assets/customer.jpg";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cFireBaseAuth.currentUser().then((user) => setState(() {
          this.user = user;
          // if(photoUrl != null){
          //   photoUrl = user.photoUrl;
          // }
          // else{
          //   photoUrl ;
          // }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        actions: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              width: 35.0,
              height: 70.0,
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  image: AssetImage('assets/customer.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ))
        ],
        leading: IconButton(
          icon: MenuIconsPage(),
          onPressed: () => _scaffoldkey.currentState.openDrawer(),
        ),
      ),
      drawer: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent.withOpacity(0.3),
          ),
          child: Drawer(
            child: Container(
              //color: Colors.black.withOpacity(0.1),
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 150,
                    alignment: Alignment.center,
                    color: Colors.black,
                    child: ListTile(
                      title: Text(
                        'Balaji Tenders',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      subtitle: Text(
                        'Address' + '\nNumber',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.home, color: Colors.white),
                          title: Text(
                            'Home',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.person, color: Colors.white),
                          title: Text(
                            'Profile',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.search, color: Colors.white),
                          title: Text(
                            'Search',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.history, color: Colors.white),
                          title: Text(
                            'History',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.payment, color: Colors.white),
                          title: Text(
                            'Payment',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Setting',
                            style: TextStyle(color: Colors.white),
                          ),
                          // onTap: () => Navigator.push(context, MaterialPageRoute(builder:  (context)=>DemoPage(widget.handleSignOut,widget._currentUser))),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: (){
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListOfItemPage()));
                });
              },
              child: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4), BlendMode.hardLight),
                        image: AssetImage(
                          'assets/grocerylist.jpg',
                        ),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 100,
                      top: 100,
                      child: Text(
                        'LIST OF ITEMS',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerListPage()));
                });
              },
              child: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4), BlendMode.hardLight),
                        image: AssetImage(
                          'assets/customer.jpg',
                        ),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 100,
                      top: 100,
                      child: Text(
                        'CUSTOMER LIST',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrderPage()));
                });
              },
              child: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4), BlendMode.hardLight),
                        image: AssetImage(
                          'assets/order.jpg',
                        ),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 150,
                      top: 100,
                      child: Text(
                        'ORDERS',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

