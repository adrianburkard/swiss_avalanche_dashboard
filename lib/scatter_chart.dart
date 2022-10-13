import 'package:flutter/material.dart';
import 'package:swiss_avalanche_dashboard/doughnut_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ScatterChart extends StatefulWidget {
  const ScatterChart({Key? key}) : super(key: key);

  @override
  State<ScatterChart> createState() => _ScatterChartState();
}

class _ScatterChartState extends State<ScatterChart> {
  get chartSampleData => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(),
                    series: <ChartSeries>[
                      // Renders scatter chart
                      ScatterSeries<ChartSampleData, DateTime>(
                          dataSource: chartSampleData,
                          xValueMapper: (ChartSampleData data, _) => data.x,
                          yValueMapper: (ChartSampleData data, _) => data.y
                      )
                    ]
                )
            )
        )
    );
  }
}
