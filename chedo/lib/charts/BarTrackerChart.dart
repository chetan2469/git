import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BarTracker extends StatelessWidget {
  const BarTracker({Key? key}) : super(key: key);

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BarTracker Flutter chart'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height / 2,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            title: ChartTitle(text: 'Working hours of employees'),
            primaryXAxis: CategoryAxis(
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
                majorGridLines: const MajorGridLines(width: 0),
                minimum: 0,
                maximum: 8,
                majorTickLines: const MajorTickLines(size: 0)),
            series: _getTrackerBarSeries(),
          ),
        ));
  }

  List<BarSeries<ChartSampleData, String>> _getTrackerBarSeries() {
    return <BarSeries<ChartSampleData, String>>[
      BarSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 'Mike', y: 7.5),
          ChartSampleData(x: 'Chris', y: 7),
          ChartSampleData(x: 'Helana', y: 6),
          ChartSampleData(x: 'Tom', y: 5),
          ChartSampleData(x: 'Federer', y: 7),
          ChartSampleData(x: 'Hussain', y: 7),
        ],
        borderRadius: BorderRadius.circular(15),
        trackColor: const Color.fromRGBO(198, 201, 207, 1),

        /// If we enable this property as true,
        /// then we can show the track of series.
        isTrackVisible: true,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, labelAlignment: ChartDataLabelAlignment.top),
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
      ),
    ];
  }
}

class ChartSampleData {
  String x;
  double y;
  ChartSampleData({required this.x, required this.y});
}
