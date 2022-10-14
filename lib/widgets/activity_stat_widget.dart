import 'package:flutter/material.dart';
import 'package:swiss_avalanche_dashboard/model/activity_deats_stat.dart';
import 'package:swiss_avalanche_dashboard/model/avalanche_accident_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ActivityView extends StatefulWidget {
  final List<AccidentData> accidentData;

  const ActivityView({Key? key, required this.accidentData}) : super(key: key);

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<ActivityDeaths>>(
            future: _getActivityDeaths(widget.accidentData),
            builder: (BuildContext context,
                AsyncSnapshot<List<ActivityDeaths>> snapshot) {
              if (snapshot.data != null) {
                return SfCartesianChart(
                    title: ChartTitle(text: 'Anzahl Tote nach Aktivität'),
                    palette: <Color>[
                      Colors.teal[300]!,
                      Colors.orange,
                      Colors.brown
                    ],
                    primaryYAxis: NumericAxis(
                        rangePadding: ChartRangePadding.normal
                    ),
                    tooltipBehavior: _tooltipBehavior,
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
                      ColumnSeries<ActivityDeaths, String>(
                        name: 'Anzahl Tote',
                        dataSource: snapshot.data!,
                        xValueMapper: (ActivityDeaths data, _) => data.activity,
                        yValueMapper: (ActivityDeaths data, _) =>
                            data.amountDeaths,
                      )
                    ]);
              }
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                ),
              );
            }),
      ),
    );
  }

  Future<List<ActivityDeaths>> _getActivityDeaths(
      List<AccidentData> data) async {
    List<List<AccidentData>> tempList = [];
    tempList
        .add(List.from(data.where((element) => element.activity == 'tour')));
    tempList.add(
        List.from(data.where((element) => element.activity == 'offpiste')));
    tempList.add(List.from(data
        .where((element) => element.activity == 'transportation.corridor')));
    tempList.add(List.from(data
        .where((element) => element.activity == 'other, mixed or unknown')));

    List<ActivityDeaths> finalList = [];
    for (var elements in tempList) {
      int amount = 0;
      for (var accidentData in elements) {
        amount += accidentData.numberDead;
      }
      finalList.add(ActivityDeaths(
          elements.elementAt(0).activity == 'tour'
              ? 'Tour'
              : elements.elementAt(0).activity == 'offpiste'
                  ? 'Offpiste'
                  : elements.elementAt(0).activity == 'transportation.corridor'
                      ? 'Transportwege'
                      : elements.elementAt(0).activity ==
                              'other, mixed or unknown'
                          ? 'Andere'
                          : 'nicht definiert',
          amount));
    }

    return finalList;
  }
}
