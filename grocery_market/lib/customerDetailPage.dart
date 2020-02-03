import 'package:flutter/material.dart';
import 'customerDatatype.dart';

class CustomerDetailPage extends StatefulWidget {
  final CustomerDataType customerdatatype;
  CustomerDetailPage({this.customerdatatype});
  @override
  _CustomerDetailPageState createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  TextEditingController nameContorller = TextEditingController();
  TextEditingController addressContorller = TextEditingController();
  TextEditingController mobileContorller = TextEditingController();
  bool agreed = false, nameEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameContorller.text = widget.customerdatatype.name;
    addressContorller.text = widget.customerdatatype.address;
    mobileContorller.text = widget.customerdatatype.mobile.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Customer Detials"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          // InkWell(
          //   child: Container(
          //     margin: EdgeInsets.all(10),
          //     child: Icon(Icons.edit,color: nameEdit?Colors.white:Colors.black),
          //   ),
          //   onTap: (){
          //     setState(() {
          //       nameEdit =! nameEdit;
          //     });
          //   },
          // )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ClipPath(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/customer.jpg',
                        ),
                        fit: BoxFit.fill)),
              ),
              clipper: BottomWaveClipper(),
            ),
            Container(
              margin: EdgeInsets.only(top: 150),
              child: Container(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  maxRadius: 70,
                  backgroundImage: NetworkImage('https://www.ctvalleybrewing.com/wp-content/uploads/2017/04/avatar-placeholder.png'),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 300),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child:  Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10),
                        child: TextField(
                          enabled: nameEdit,
                          controller: nameContorller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: TextField(
                          enabled: nameEdit,
                          controller: addressContorller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: TextField(
                          enabled: nameEdit,
                          controller: mobileContorller,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                    ],
                  ),
            )
          ],
        ),
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 110);
    path.lineTo(
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
