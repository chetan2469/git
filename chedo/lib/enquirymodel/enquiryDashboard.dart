import 'package:cached_network_image/cached_network_image.dart';
import 'package:chedo/enquirymodel/addEnquiryPage.dart';
import 'package:chedo/enquirymodel/enquiryFrom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'enquiryList.dart';

class EnquiryDashboard extends StatefulWidget {
  const EnquiryDashboard({Key? key}) : super(key: key);

  @override
  _EnquiryDashboardState createState() => _EnquiryDashboardState();
}

final List<ChartData> chartData = [
  ChartData('All Enquiries', 154, Colors.white),
  ChartData('Hired', 91, Colors.black),
];

class _EnquiryDashboardState extends State<EnquiryDashboard> {
  List<EnquiryFromOption> enqFromList = [];
  bool processing = false;

  @override
  void initState() {
    super.initState();
    fetchEnquiryFromData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Icon(Icons.add),
        //   backgroundColor: Colors.indigo,
        // ),
        body: Column(
          children: [
            Expanded(
                child: ListTile(
              leading: const Icon(Icons.menu),
              title: const Text(
                'Enquiry Dashboard',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: InkWell(
                  onTap: () {
                    Get.to(() => EnquiryListView(enqFromList));
                  },
                  child: const Icon(Icons.list)),
            )),
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.only(
                    left: 20, right: 20, top: 1, bottom: 1),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(146, 163, 253, .7),
                    borderRadius: BorderRadius.circular(30)),
                child: Stack(
                  children: [
                    Positioned(
                        left: -9,
                        bottom: -9,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(.4),
                          ),
                          width: 50,
                          height: 50,
                        )),
                    Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(.4),
                          ),
                          width: 50,
                          height: 50,
                        )),
                    Positioned(
                        left: 130,
                        top: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(.4),
                          ),
                          width: 10,
                          height: 10,
                        )),
                    Positioned(
                        left: 180,
                        top: 120,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(.4),
                          ),
                          width: 10,
                          height: 10,
                        )),
                    Positioned(
                        left: 120,
                        top: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(.4),
                          ),
                          width: 10,
                          height: 10,
                        )),
                    Positioned(
                        left: 170,
                        top: 25,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(.4),
                          ),
                          width: 10,
                          height: 10,
                        )),
                    Positioned(
                        left: 30,
                        top: 30,
                        child: Container(
                          child: const Text(
                            'Enquiries',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        )),
                    Positioned(
                        left: 30,
                        bottom: 60,
                        child: InkWell(
                          onTap: () => Get.to(() => AddEnquiryPage(
                                enqFromList: enqFromList,
                              )),
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 10, right: 20, left: 20, bottom: 10),
                            child: const Text(
                              '  Add Enquiry  ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(197, 139, 242, .9),
                                borderRadius: BorderRadius.circular(30)),
                          ),
                        )),
                    Positioned(
                        right: 30,
                        top: 10,
                        child: SizedBox(
                            width: 140,
                            height: 140,
                            child: SfCircularChart(palette: <Color>[
                              Colors.white,
                              const Color.fromRGBO(197, 139, 242, .9),
                            ], series: <CircularSeries>[
                              // Render pie chart
                              PieSeries<ChartData, String>(
                                  dataSource: chartData,
                                  dataLabelSettings:
                                      const DataLabelSettings(isVisible: true),
                                  xValueMapper: (ChartData data, _) =>
                                      data.x.toString(),
                                  yValueMapper: (ChartData data, _) => data.y)
                            ]))),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 10,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: processing
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 3,
                          ),
                          itemCount: enqFromList.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return Container(
                              margin: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Colors.grey,
                                    offset: const Offset(0.0, 1.0), //(x,y)
                                    blurRadius: 3.0,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                      top: 20,
                                      left: 20,
                                      child: Text(enqFromList[index].name)),
                                  Positioned(
                                      right: 10,
                                      top: 10,
                                      child: SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: CachedNetworkImage(
                                          imageUrl: enqFromList[index].imageUrl,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      )),
                                  Positioned(
                                      bottom: 50,
                                      left: 40,
                                      child: Text(
                                        enqFromList[index].data,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                                ],
                              ),
                            );
                          }),
                ))
          ],
        ),
      ),
    );
  }

  // void insert() async {
  //   await FirebaseFirestore.instance
  //       .collection('enquiryLeedsPlatforms')
  //       .doc()
  //       .set({
  //     'name': 'enqFromList[0].name',
  //     'imageUrl': 'enqFromList[0].imageUrl',
  //     'data': '0/0',
  //   });
  // }

  fetchEnquiryFromData() async {
    setState(() {
      processing = true;
      enqFromList.clear();
    });

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('enquiryLeedsPlatforms')
        .get();

    final List<DocumentSnapshot> documents = result.docs;
    documents.forEach((data) {
      EnquiryFromOption record = EnquiryFromOption(
        name: (data as dynamic)['name'],
        imageUrl: (data as dynamic)['imageUrl'],
        data: (data as dynamic)['data'],
      );
      enqFromList.add(record);
    });

    enqFromList
      ..sort((a, b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    setState(() {
      processing = false;
    });
  }

  void loadOptions() {
    setState(() {
      enqFromList.clear();
    });
    setState(() {
      enqFromList.add(EnquiryFromOption(
          name: 'Google',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/flutter-chedo.appspot.com/o/icons%2Fgoogle.png?alt=media&token=4f411be6-49fb-46fa-bf94-555edfb83c79',
          data: '21/45'));

      enqFromList.add(EnquiryFromOption(
          name: 'Facebook',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/flutter-chedo.appspot.com/o/icons%2Ffb.png?alt=media&token=60a2434c-caef-43c7-a73e-13d72c81dace',
          data: '11/57'));

      enqFromList.add(EnquiryFromOption(
          name: 'Urban Pro',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/flutter-chedo.appspot.com/o/icons%2Fupro.jpg?alt=media&token=403441e3-35f5-4ac4-95d6-b3b52d385db3',
          data: '5/20'));

      enqFromList.add(EnquiryFromOption(
          name: 'Sulekha',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/flutter-chedo.appspot.com/o/icons%2Fsulekha.jpeg?alt=media&token=22b3f483-423c-4f9f-918b-e606e10ce9b9',
          data: '66/212'));

      enqFromList.add(EnquiryFromOption(
          name: 'Just Dial',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/flutter-chedo.appspot.com/o/icons%2Fjd.jpg?alt=media&token=a35d4a77-0700-44a7-898b-009a41a2bef6',
          data: '12/45'));

      enqFromList.add(EnquiryFromOption(
          name: 'Location',
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/flutter-chedo.appspot.com/o/icons%2Floc.jpg?alt=media&token=67e5dbe4-9e2e-4d85-bec8-093db5e8d676',
          data: '43/55'));
    });
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class MyArc extends StatelessWidget {
  final double diameter;

  const MyArc({this.diameter = 200});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: Size(diameter, diameter),
    );
  }
}

// This is the Painter class
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color.fromRGBO(197, 139, 242, .9);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      4,
      3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
