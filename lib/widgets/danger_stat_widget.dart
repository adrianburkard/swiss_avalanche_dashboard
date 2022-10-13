import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/avalanche_accident_data.dart';
import '../model/danger_deaths_stat.dart';

class DangerView extends StatefulWidget {
  final List<AccidentData> accidentData;

  const DangerView({
    Key? key,
    required this.accidentData,
  }) : super(key: key);

  @override
  State<DangerView> createState() => DangerViewState();
}

class DangerViewState extends State<DangerView> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 20,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<DangerDeaths>>(
              future: _getDangerDeaths(widget.accidentData),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DangerDeaths>> snapshot) {
                if (snapshot.data != null) {
                  return SfCircularChart(series: <CircularSeries>[
                    // Renders scatter chart
                    DoughnutSeries<DangerDeaths, int>(
                      dataSource: snapshot.data!,
                      xValueMapper: (DangerDeaths data, _) => data.amountDeaths,
                      yValueMapper: (DangerDeaths data, _) => data.dangerLevel,
                    )
                  ]);
                }
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                  ),
                );
              }),
        ));
  }

  Future<List<DangerDeaths>> _getDangerDeaths(List<AccidentData> data) async {
    List<DangerDeaths> listDangerDeaths = [];

    for (var i = 1; i < 6; i++) {
      List<AccidentData> tempList = [];
      tempList
          .addAll(List.from(data.where((element) => element.dangerLevel == i)));
      int amount = 0;
      for (var el in data) {
        amount += el.numberDead;
      }
      listDangerDeaths.add(DangerDeaths(i, amount));
    }

    return listDangerDeaths;
  }
}
