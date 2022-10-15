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
  State<DangerView> createState() => _DangerViewState();
}

class _DangerViewState extends State<DangerView> {
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
              child: FutureBuilder<List<DangerDeaths>>(
                  future: _getDangerDeaths(widget.accidentData),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DangerDeaths>> snapshot) {
                    if (snapshot.data != null) {
                      return SfCircularChart(
                          title: ChartTitle(text: 'Anzahl Tote nach Gefahrenstufe'),
                          legend: Legend(
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap,
                          ),
                          palette: <Color>[
                            Colors.green,
                            Colors.yellow[500]!,
                            Colors.orange[700]!,
                            Colors.red[500]!,
                            Colors.red[900]!,
                          ],
                          tooltipBehavior: _tooltipBehavior,
                          series: <CircularSeries>[
                            // Renders scatter chart
                            DoughnutSeries<DangerDeaths, String>(
                                dataSource: snapshot.data!,
                                xValueMapper: (DangerDeaths data, _) =>
                                    data.dangerLevel.toString(),
                                yValueMapper: (DangerDeaths data, _) =>
                                    data.amountDeaths,
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true))
                          ]);
                    }
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                      ),
                    );
                  }),
            )),
        const Positioned( // will be positioned in the top right of the container
          top: 10,
          right: 10,
          child: Tooltip(
            message: 'Das Kreisdiagramm teilt die Anzahl Lawinentoten nach \n'
                'der am Ereignistag ausgegebenen Lawinengefahr ein. \n'
                '1: gering \n'
                '2: mässig \n'
                '3: erheblich \n'
                '4: gross \n'
                '5: sehr gross',
            child: Icon(
              Icons.help_outline,
              color: Colors.teal,
            ),
          ),
        ),
      ],
    );
  }

  Future<List<DangerDeaths>> _getDangerDeaths(List<AccidentData> data) async {
    List<DangerDeaths> listDangerDeaths = [];

    for (var i = 1; i < 6; i++) {
      List<AccidentData> tempList = [];
      tempList
          .addAll(List.from(data.where((element) => element.dangerLevel == i)));
      int amount = 0;
      for (var el in tempList) {
        amount += el.numberDead;
      }
      listDangerDeaths.add(DangerDeaths(i, amount));
    }

    return listDangerDeaths;
  }
}
