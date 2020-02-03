import 'package:flutter/material.dart';

import 'itemDatatype.dart';
import 'orderDataType.dart';

class OrderViewPage extends StatefulWidget {
  final OrderDataType orderDataType;
  OrderViewPage({this.orderDataType});
  @override
  _OrderViewPageState createState() => _OrderViewPageState();
}

class _OrderViewPageState extends State<OrderViewPage> {
  List<ItemDataType> itemList = List();
  bool boxvalue = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController itemriceController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.orderDataType.name;
    itemNameController.text = widget.orderDataType.product;
    setState(() {
      itemList.add(ItemDataType(
          itemName: 'Shugar',
          itemQuantity: '2',
          itemrice: '30',
          itemUnite: 'kg'));
      itemList.add(ItemDataType(
          itemName: 'Rice',
          itemQuantity: '2',
          itemrice: '30',
          itemUnite: 'kg'));
      itemList.add(ItemDataType(
          itemName: 'Dhal',
          itemQuantity: '2',
          itemrice: '30',
          itemUnite: 'kg'));
      itemList.add(ItemDataType(
          itemName: 'Honey',
          itemQuantity: '2',
          itemrice: '30',
          itemUnite: 'kg'));
      itemList.add(ItemDataType(
          itemName: 'Maggi',
          itemQuantity: '2',
          itemrice: '30',
          itemUnite: 'kg'));
      itemList.add(ItemDataType(
          itemName: 'HandWash',
          itemQuantity: '2',
          itemrice: '30',
          itemUnite: 'kg'));
      itemList.add(ItemDataType(
          itemName: 'Hair Oil',
          itemQuantity: '2',
          itemrice: '30',
          itemUnite: 'kg'));
      itemList.add(ItemDataType(
          itemName: 'Shugar',
          itemQuantity: '2',
          itemrice: '30',
          itemUnite: 'kg'));
      itemList.add(ItemDataType(
          itemName: 'Shugar',
          itemQuantity: '2',
          itemrice: '30',
          itemUnite: 'kg'));
      itemList.add(ItemDataType(
          itemName: 'Shugar',
          itemQuantity: '2',
          itemrice: '30',
          itemUnite: 'kg'));
      itemList.add(ItemDataType(
          itemName: 'Shugar',
          itemQuantity: '2',
          itemrice: '30',
          itemUnite: 'kg'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Customer Order Details'),
        backgroundColor: Colors.green,
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
                          'assets/order.jpg',
                        ),
                        fit: BoxFit.fill)),
              ),
              clipper: BottomWaveClipper(),
            ),
            Container(
              padding: EdgeInsets.only(top: 235),
              margin: EdgeInsets.all(12),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green[200],
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          'Item Name',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('Item Quantity',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text('Avaliable',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.only(top: 290),
                margin: EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.green[100], Colors.green]),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(itemList[index].itemName),
                            )),
                            Expanded(
                                child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(itemList[index].itemQuantity +
                                  '\t' +
                                  itemList[index].itemUnite),
                            )),
                            Expanded(
                                child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Checkbox(
                                value: boxvalue,
                                checkColor: Colors.black,
                                activeColor:
                                    Colors.transparent.withOpacity(0.3),
                                onChanged: (bool value) {
                                  setState(() {
                                    boxvalue = value;
                                  });
                                },
                              ),
                            )),
                          ],
                        ),
                      ),
                    );
                  },
                ))
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
