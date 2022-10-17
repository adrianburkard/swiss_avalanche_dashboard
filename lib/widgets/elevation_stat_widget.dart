import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/avalanche_accident_data.dart';
import '../model/elevation_deaths_stat.dart';

class ElevationView extends StatefulWidget {
  final List<AccidentData> accidentData;

  const ElevationView({
    Key? key,
    required this.accidentData,
  }) : super(key: key);

  @override
  State<ElevationView> createState() => _ElevationViewState();
}

class _ElevationViewState extends State<ElevationView> {
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
            child: FutureBuilder<List<ElevationDeaths>>(
              future: _getElevationDeaths(widget.accidentData),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ElevationDeaths>> snapshot) {
                if (snapshot.data != null) {
                  return SfCartesianChart(
                    title: ChartTitle(text: 'Anzahl Tote nach Höhenlage'),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Anzahl Tote',
                      ),
                    ),
                    primaryXAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Höhe [m ü. M.]',
                      ),
                    ),
                    isTransposed: true,
                    tooltipBehavior: _tooltipBehavior,
                    series: <ChartSeries>[
                      HistogramSeries<ElevationDeaths, double>(
                          name: 'Anzahl Tote',
                          enableTooltip: true,
                          dataSource: snapshot.data!,
                          showNormalDistributionCurve: true,
                          color: Colors.teal[300],
                          curveColor: Colors.teal[900]!,
                          binInterval: 200,
                          yValueMapper: (ElevationDeaths data, _) =>
                              data.elevation),
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
            message: 'Das Balkendiagramm zeigt in welcher Höhe die Lawinen \n'
                'ausgelöst wurden, die zu den Todesfällen führten. Die \n'
                'schwarze Kurve zeigt die Normalverteilung der Daten.',
            child: Icon(
              Icons.help_outline,
              color: Colors.teal,
            ),
          ),
        ),
      ],
    );
  }

  Future<List<ElevationDeaths>> _getElevationDeaths(
      List<AccidentData> data) async {
    List<ElevationDeaths> listElevationDeaths = [];
    for (var element in data) {
      for (int i = 0; i < element.numberDead; i++) {
        listElevationDeaths.add(ElevationDeaths(element.elevation, 1));
      }
    }

    return listElevationDeaths;
  }
}
