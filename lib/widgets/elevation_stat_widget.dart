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
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<ElevationDeaths>>(
          future: _getElevationDeaths(widget.accidentData),
          builder: (BuildContext context,
              AsyncSnapshot<List<ElevationDeaths>> snapshot) {
            if (snapshot.data != null) {
              return SfCartesianChart(isTransposed: true, series: <ChartSeries>[
                HistogramSeries<ElevationDeaths, double>(
                    dataSource: snapshot.data!,
                    showNormalDistributionCurve: true,
                    // curveColor: const Color.fromRGBO(192, 108, 132, 1),
                    binInterval: 200,
                    yValueMapper: (ElevationDeaths data, _) => data.elevation)
              ]);
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

  Future<List<ElevationDeaths>> _getElevationDeaths(List<AccidentData> data) async {
    List<ElevationDeaths> listElevationDeaths = [];
    for (var element in data) {
      for (int i = 0; i < element.numberDead; i++) {
        listElevationDeaths.add(ElevationDeaths(element.elevation, 1));
      }
    }

    return listElevationDeaths;
  }

}
