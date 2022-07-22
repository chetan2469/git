import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class CartesianChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _MyHomePage();
  }
}

class _MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  List<_SalesData> data = [
    _SalesData('2001', 35),
    _SalesData('2002', 28),
    _SalesData('2003', 34),
    _SalesData('2004', 32),
    _SalesData('2005', 40),
    _SalesData('2006', 85),
    _SalesData('2007', 28),
    _SalesData('2008', 24),
    _SalesData('2009', 42),
    _SalesData('2010', 65)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height / 2,
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Sales',
                    color: Colors.red,
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
        ));
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
