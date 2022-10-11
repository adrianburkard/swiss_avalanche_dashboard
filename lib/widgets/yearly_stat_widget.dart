import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/avalanche_accident_data.dart';
import '../model/yearly_deaths_stat.dart';

class YearlyStatView extends StatefulWidget {
  final List<AccidentData> accidentData;

  const YearlyStatView({
    Key? key,
    required this.accidentData,
  }) : super(key: key);

  @override
  State<YearlyStatView> createState() => _YearlyStatViewState();
}

class _YearlyStatViewState extends State<YearlyStatView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<YearlyDeaths>>(
          future: _getYearlyStat(widget.accidentData),
          builder: (BuildContext context,
              AsyncSnapshot<List<YearlyDeaths>> snapshot2) {
            if (snapshot2.data != null) {
              return SfCartesianChart(
                series: <ChartSeries>[
                  // Renders line chart
                  LineSeries<YearlyDeaths, int>(
                    dataSource: snapshot2.data!,
                    xValueMapper: (YearlyDeaths data, _) => data.year,
                    yValueMapper: (YearlyDeaths data, _) => data.amountDeaths,
                  )
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<List<YearlyDeaths>> _getYearlyStat(List<AccidentData> data) async {
    List<YearlyDeaths> listYearlyDeaths = [];
    for (int i = 1995; i < 2022; i++) {
      DateTime year = DateTime(i);
      List<AccidentData> yearlyAccident =
          List.from(data.where((element) => element.date.year == year.year));
      // _listYearlyDeaths.add(yearlyAccident);
      int num = 0;
      yearlyAccident.forEach((element) {
        num += element.numberDead;
      });
      listYearlyDeaths.add(YearlyDeaths(i, num));
    }
    listYearlyDeaths.removeAt(0);

    return listYearlyDeaths;
  }
}
