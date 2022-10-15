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
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<YearlyDeaths>>(
              future: _getYearlyStat(widget.accidentData),
              builder: (BuildContext context,
                  AsyncSnapshot<List<YearlyDeaths>> snapshot) {
                if (snapshot.data != null) {
                  return SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior,
                    primaryXAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Jahr',
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Anzahl Tote'
                      )
                    ),
                    title: ChartTitle(text: 'Anzahl Tote von 1996 - 2020'),
                    palette: const <Color>[
                      Colors.teal,
                      Colors.orange,
                      Colors.brown,
                    ],
                    series: <ChartSeries>[
                      // Renders line chart
                      SplineSeries<YearlyDeaths, int>(
                        name: 'Anzahl Tote',
                        enableTooltip: true,
                        dataSource: snapshot.data!,
                        xValueMapper: (YearlyDeaths data, _) => data.year,
                        yValueMapper: (YearlyDeaths data, _) => data.amountDeaths,
                      )
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                  ),
                );
              },
            ),
          ),
        ),
        const Positioned( // will be positioned in the top right of the container
          top: 10,
          right: 10,
          child: Tooltip(
            message: 'Das Liniendiagramm teilt die Lawinentoten nach \n'
                'Verschüttungsjahr auf. Dabei werden die Jahre 1996 \n'
                'bis 2020 betrachtet.',
            child: Icon(
              Icons.help_outline,
              color: Colors.teal,
            ),
          ),
        ),
      ],
    );
  }

  Future<List<YearlyDeaths>> _getYearlyStat(List<AccidentData> data) async {
    List<YearlyDeaths> listYearlyDeaths = [];
    for (int i = 1995; i < 2022; i++) {
      DateTime year = DateTime(i);
      List<AccidentData> yearlyAccident =
          List.from(data.where((element) => element.date.year == year.year));
      int num = 0;
      for (var element in yearlyAccident) {
        num += element.numberDead;
      }
      listYearlyDeaths.add(YearlyDeaths(i, num));
    }
    listYearlyDeaths.removeAt(0);

    return listYearlyDeaths;
  }
}
