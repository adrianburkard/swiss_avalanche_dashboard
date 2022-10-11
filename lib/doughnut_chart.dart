import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChart extends StatefulWidget {
  const DoughnutChart({Key? key}) : super(key: key);

  @override
  State<DoughnutChart> createState() => _DoughnutChartState();
}

class _DoughnutChartState extends State<DoughnutChart> {
  _DoughnutChartState();

  @override
  Widget build(BuildContext context) {
    return _buildDoughnutCustomizationChart();
  }

  /// Returns the circular chart with color mapping doughnut series.
  SfCircularChart _buildDoughnutCustomizationChart() {
    return SfCircularChart(
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
            widget: const Text('90%',
                style: TextStyle(fontSize: 20)))
      ],
      title: ChartTitle(
          text: 'Work progress', textStyle: const TextStyle(fontSize: 12)),
      series: _getDoughnutCustomizationSeries(),
    );
  }

  /// Return the list of doughnut series which need to be color mapping.
  List<DoughnutSeries<ChartSampleData, String>>
      _getDoughnutCustomizationSeries() {
    return <DoughnutSeries<ChartSampleData, String>>[
      DoughnutSeries<ChartSampleData, String>(
        dataSource: <ChartSampleData>[
          ChartSampleData(
              x: 'A', y: 10, pointColor: const Color.fromRGBO(255, 4, 0, 1)),
          ChartSampleData(
              x: 'B', y: 10, pointColor: const Color.fromRGBO(255, 15, 0, 1)),
          ChartSampleData(
              x: 'C', y: 10, pointColor: const Color.fromRGBO(255, 31, 0, 1)),
          ChartSampleData(
              x: 'D', y: 10, pointColor: const Color.fromRGBO(255, 60, 0, 1)),
          ChartSampleData(
              x: 'E', y: 10, pointColor: const Color.fromRGBO(255, 90, 0, 1)),
          ChartSampleData(
              x: 'F', y: 10, pointColor: const Color.fromRGBO(255, 115, 0, 1)),
          ChartSampleData(
              x: 'G', y: 10, pointColor: const Color.fromRGBO(255, 135, 0, 1)),
          ChartSampleData(
              x: 'H', y: 10, pointColor: const Color.fromRGBO(255, 155, 0, 1)),
          ChartSampleData(
              x: 'I', y: 10, pointColor: const Color.fromRGBO(255, 175, 0, 1)),
          ChartSampleData(
              x: 'J', y: 10, pointColor: const Color.fromRGBO(255, 188, 0, 1)),
          ChartSampleData(
              x: 'K', y: 10, pointColor: const Color.fromRGBO(255, 188, 0, 1)),
          ChartSampleData(
              x: 'L', y: 10, pointColor: const Color.fromRGBO(251, 188, 2, 1)),
          ChartSampleData(
              x: 'M', y: 10, pointColor: const Color.fromRGBO(245, 188, 6, 1)),
          ChartSampleData(
              x: 'N', y: 10, pointColor: const Color.fromRGBO(233, 188, 12, 1)),
          ChartSampleData(
              x: 'O', y: 10, pointColor: const Color.fromRGBO(220, 187, 19, 1)),
          ChartSampleData(
              x: 'P', y: 10, pointColor: const Color.fromRGBO(208, 187, 26, 1)),
          ChartSampleData(
              x: 'Q', y: 50, pointColor: const Color.fromRGBO(193, 187, 34, 1)),
          ChartSampleData(
              x: 'R', y: 40, pointColor: const Color.fromRGBO(177, 186, 43, 1)),
          ChartSampleData(
              x: 'S', y: 30, pointColor: const Color.fromRGBO(230, 230, 230, 1)),
          ChartSampleData(
              x: 'T', y: 20, pointColor: const Color.fromRGBO(230, 230, 230, 1))
        ],
        radius: '100%',
        strokeColor:
            Theme.of(context).colorScheme.brightness == Brightness.light
                ? Colors.white
                : Colors.black,
        strokeWidth: 2,
        xValueMapper: (ChartSampleData data, _) => data.x as String,
        yValueMapper: (ChartSampleData data, _) => data.y,

        /// The property used to apply the color for each douchnut series.
        pointColorMapper: (ChartSampleData data, _) => data.pointColor,
        dataLabelMapper: (ChartSampleData data, _) => data.x as String,
      ),
    ];
  }
}

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}
