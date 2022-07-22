import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnChart extends StatefulWidget {
  const ColumnChart({Key? key}) : super(key: key);

  @override
  _ColumnChartState createState() => _ColumnChartState();
}

class _ColumnChartState extends State<ColumnChart> {
  TooltipBehavior? _tooltipBehavior =
      TooltipBehavior(enable: true, header: '', canShowMarker: false);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                      axisLine: const AxisLine(width: 0),
                      labelFormat: '{value}%',
                      majorTickLines: const MajorTickLines(size: 0)),
                  series: _getDefaultColumnSeries(),
                  tooltipBehavior: _tooltipBehavior,
                ),
              ),
            ),
            Expanded(
              child: Container(
                  child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: 100,
                    axisLine: const AxisLine(width: 0),
                    majorGridLines: const MajorGridLines(width: 0),
                    majorTickLines: const MajorTickLines(size: 0)),
                series: _getTracker(),
                tooltipBehavior: _tooltipBehavior,
              )),
            ),
            Expanded(
              child: SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: CategoryAxis(
                  labelStyle: const TextStyle(color: Colors.white),
                  axisLine: const AxisLine(width: 0),
                  labelPosition: ChartDataLabelPosition.inside,
                  majorTickLines: const MajorTickLines(width: 0),
                  majorGridLines: const MajorGridLines(width: 0),
                ),
                primaryYAxis:
                    NumericAxis(isVisible: false, minimum: 0, maximum: 9000),
                series: _getRoundedColumnSeries(),
                tooltipBehavior: _tooltipBehavior,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ColumnSeries<ChartSampleData, String>> _getTracker() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
          dataSource: <ChartSampleData>[
            ChartSampleData(x: 'Subject 1', y: 71),
            ChartSampleData(x: 'Subject 2', y: 84),
            ChartSampleData(x: 'Subject 3', y: 48),
            ChartSampleData(x: 'Subject 4', y: 80),
            ChartSampleData(x: 'Subject 5', y: 76),
          ],

          /// We can enable the track for column here.
          isTrackVisible: true,
          trackColor: const Color.fromRGBO(198, 201, 207, 1),
          borderRadius: BorderRadius.circular(15),
          xValueMapper: (ChartSampleData sales, _) => sales.x as String,
          yValueMapper: (ChartSampleData sales, _) => sales.y,
          name: 'Marks',
          dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.top,
              textStyle: TextStyle(fontSize: 10, color: Colors.white)))
    ];
  }

  List<ColumnSeries<ChartSampleData, String>> _getDefaultColumnSeries() {
    return <ColumnSeries<ChartSampleData, String>>[
      ColumnSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData(x: 'China', y: 0.541),
          ChartSampleData(x: 'Brazil', y: 0.518),
          ChartSampleData(x: 'Bolivia', y: .51),
          ChartSampleData(x: 'Mexico', y: .302),
          ChartSampleData(x: 'Egypt', y: .017),
          ChartSampleData(x: 'Mongolia', y: .683),
        ],
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        dataLabelSettings: const DataLabelSettings(
            isVisible: true, textStyle: TextStyle(fontSize: 10)),
      )
    ];
  }
}

List<ColumnSeries<ChartSampleData, String>> _getRoundedColumnSeries() {
  return <ColumnSeries<ChartSampleData, String>>[
    ColumnSeries<ChartSampleData, String>(
      width: 0.9,
      dataLabelSettings: const DataLabelSettings(
          isVisible: true, labelAlignment: ChartDataLabelAlignment.top),
      dataSource: <ChartSampleData>[
        ChartSampleData(x: 'New York', y: 8683),
        ChartSampleData(x: 'Tokyo', y: 6993),
        ChartSampleData(x: 'Chicago', y: 5498),
        ChartSampleData(x: 'Atlanta', y: 5083),
        ChartSampleData(x: 'Boston', y: 4497),
      ],

      /// If we set the border radius value for column series,
      /// then the series will appear as rounder corner.
      borderRadius: BorderRadius.circular(10),
      xValueMapper: (ChartSampleData sales, _) => sales.x as String,
      yValueMapper: (ChartSampleData sales, _) => sales.y,
    ),
  ];
}

class ChartSampleData {
  String x;
  double y;
  ChartSampleData({required this.x, required this.y});
}
