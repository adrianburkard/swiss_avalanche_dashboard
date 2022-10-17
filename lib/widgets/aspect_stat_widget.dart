import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

import '../model/avalanche_accident_data.dart';

class AspectView extends StatefulWidget {
  final List<AccidentData> accidentData;

  const AspectView({Key? key, required this.accidentData}) : super(key: key);

  @override
  State<AspectView> createState() => _AspectViewState();
}

class _AspectViewState extends State<AspectView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 20,
          child: FutureBuilder<List<List<num>>>(
            future: _getAspectData(widget.accidentData),
            builder:
                (BuildContext context, AsyncSnapshot<List<List<num>>> snapshot) {
              if (snapshot.data != null) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'Anzahl Tote nach Hanglage',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Expanded(
                      child: RadarChart(
                        sides: 0,
                        data: snapshot.data!,
                        features: _getAspectValues(),
                        ticks: _getAspectTicks(),
                        outlineColor: Colors.grey,
                        graphColors: const <Color>[
                          Colors.teal,
                          Colors.orange,
                          Colors.brown
                        ],
                        // maxValue: 10,
                        // fillColor: Colors.blue,
                        // chartRadiusFactor: 0.85,
                        // textScaleFactor: 0.035,
                      ),
                    ),
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
        const Positioned( // will be positioned in the top right of the container
          top: 10,
          right: 10,
          child: Tooltip(
            message: 'Das Diagramm teilt die Lawinentoten nach Exposition ein, \n'
                'in der die Lawine ausgelöst wurde. Ein Ring im Diagramm \n'
                'entspricht jeweils zehn Todesopfern. Die Expositionen sind, \n'
                'equivalent zu einem Kompass, ganz aussen aufgetragen.',
            child: Icon(
              Icons.help_outline,
              color: Colors.teal,
            ),
          ),
        ),
      ],
    );
  }

  Future<List<List<int>>> _getAspectData(List<AccidentData> data) async {
    List<List<AccidentData>> listSorted = _getAspectList(data);

    List<int> deathsSortedByAspect = [];
    for (var el in listSorted) {
      int numDead = 0;
      for (var i in el) {
        numDead += i.numberDead;
      }
      deathsSortedByAspect.add(numDead);
    }

    List<int> numAccidentByAspect = [];
    for (var el in listSorted) {
      numAccidentByAspect.add(el.length);
    }

    return [deathsSortedByAspect];
  }

  List<String> _getAspectValues() {
    return [
      'N',
      'NNO',
      'NO',
      'ONO',
      'O',
      'OSO',
      'SO',
      'SSO',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW',
    ];
  }

  List<int> _getAspectTicks() {
    return [10, 20, 30, 40, 50, 60, 70, 81];
  }

  List<List<AccidentData>> _getAspectList(List<AccidentData> list) {
    List<List<AccidentData>> tempList = [];
    tempList.add(List.from(list.where((element) => element.aspect == 'N')));
    tempList.add(List.from(list.where((element) => element.aspect == 'NNE')));
    tempList.add(List.from(list.where((element) => element.aspect == 'NE')));
    tempList.add(List.from(list.where((element) => element.aspect == 'ENE')));
    tempList.add(List.from(list.where((element) => element.aspect == 'E')));
    tempList.add(List.from(list.where((element) => element.aspect == 'ESE')));
    tempList.add(List.from(list.where((element) => element.aspect == 'SE')));
    tempList.add(List.from(list.where((element) => element.aspect == 'SSE')));
    tempList.add(List.from(list.where((element) => element.aspect == 'S')));
    tempList.add(List.from(list.where((element) => element.aspect == 'SSW')));
    tempList.add(List.from(list.where((element) => element.aspect == 'SW')));
    tempList.add(List.from(list.where((element) => element.aspect == 'WSW')));
    tempList.add(List.from(list.where((element) => element.aspect == 'W')));
    tempList.add(List.from(list.where((element) => element.aspect == 'WNW')));
    tempList.add(List.from(list.where((element) => element.aspect == 'NW')));
    tempList.add(List.from(list.where((element) => element.aspect == 'NNW')));
    return tempList;
  }
}
