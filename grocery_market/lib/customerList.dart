import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'customerDatatype.dart';
import 'customerDetailPage.dart';
import 'dashBoardPage.dart';
import 'demo/menuIcons.dart';

class CustomerListPage extends StatefulWidget {
  // final Function handleSignOut;
  // final GoogleSignInAccount _currentUser;
  // CustomerListPage(this.handleSignOut,this._currentUser);
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  List<CustomerDataType> customerList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    customerList.add(CustomerDataType(
        id: 1,
        name: 'Tejas Chinni',
        address: 'Vit College,Bibvewadi',
        mobile: 9762673744));
    customerList.add(CustomerDataType(
        id: 2,
        name: 'Sameer Thorate',
        address: 'City Pride, Swargate',
        mobile: 9898989898));
    // customerList.add(CustomerDataType(
    //     id: 3,
    //     name: 'Shubham kustra',
    //     address: 'Karve Raod Nulstop',
    //     mobile: 9898989898));
    // customerList.add(CustomerDataType(
    //     id: 4,
    //     name: 'Rohan Yangatwar',
    //     address: 'Shivaji Nagr Pune',
    //     mobile: 9898989898));
    // customerList.add(CustomerDataType(
    //     id: 5,
    //     name: 'Rahul Arte ',
    //     address: 'Amar plaza ',
    //     mobile: 9898989898));
    // customerList.add(CustomerDataType(
    //     id: 6,
    //     name: 'Ashok Chnu',
    //     address: 'Station Road',
    //     mobile: 9898989898));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Customer List'),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: Icon(
              Icons.search,
              size: 30,
            ),
          )
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
                          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardPage())),
                        ),
                        ListTile(
                          leading: Icon(Icons.person, color: Colors.white),
                          title: Text(
                            'Profile',
                            style: TextStyle(color: Colors.white),
                          ),
                          // onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardPage(widget.handleSignOut, widget._currentUser))),
                        ),
                        ListTile(
                          leading: Icon(Icons.search, color: Colors.white),
                          title: Text(
                            'Search',
                            style: TextStyle(color: Colors.white),
                          ),
                          // onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardPage(widget.handleSignOut, widget._currentUser))),
                        ),
                        ListTile(
                          leading: Icon(Icons.history, color: Colors.white),
                          title: Text(
                            'History',
                            style: TextStyle(color: Colors.white),
                          ),
                          // onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardPage(widget.handleSignOut, widget._currentUser))),
                        ),
                        ListTile(
                          leading: Icon(Icons.payment, color: Colors.white),
                          title: Text(
                            'Payment',
                            style: TextStyle(color: Colors.white),
                          ),
                          //   onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardPage(widget.handleSignOut, widget._currentUser))),
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
                          // onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardPage(widget.handleSignOut, widget._currentUser))),
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
      body: Center(
          child: SizedBox(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: ListView.builder(
            itemCount: customerList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/wallpaper.jpg'),
                  ),
                  title: Text(customerList[index].name),
                  subtitle: Text(customerList[index].address),
                  trailing: Container(
                    height: 25,
                    width: 69,
                    child: Center(child: Icon(Icons.arrow_forward_ios)),
                  ),
                  onTap: () {
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerDetailPage(customerdatatype: customerList[index],)));
                    });
                  },
                ),
              );
            },
          ),
        ),
      )),
    );
  }
}
