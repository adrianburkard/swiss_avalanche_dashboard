import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:json_theme/json_theme.dart';
import 'package:swiss_avalanche_dashboard/widgets/map_widget.dart';
import 'package:swiss_avalanche_dashboard/widgets/yearly_stat_widget.dart';
// import 'package:multi_charts/multi_charts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'doughnut_chart.dart';
import 'model/avalanche_accident_data.dart';
import 'model/yearly_deaths_stat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MapZoomPanBehavior _mapZoomPanBehavior;
  // List<AccidentData> _listAccidentData = [];
  List<List<AccidentData>> _listYearlyDeaths = [];
  List<YearlyDeaths> _yearlyStat = [];
  List<List<AccidentData>> _listAspectData = [];
  List<int> _deathsSortedByAspect = [];
  List<int> _numIncidentByAspect = [];

  @override
  void initState() {
    // _mapSource = const MapShapeSource.asset(
    //   'swissBOUNDARIES3D_1_3_TLM_KANTONSGEBIET.json',
    //   shapeDataField: 'NAME',
    // );

    // _loadAsset().then((value) {
    //   _listAccidentData.addAll(value);
    //   for (int i = 1995; i < 2022; i++) {
    //     DateTime year = DateTime(i);
    //     List<AccidentData> yearlyAccident = List.from(_listAccidentData
    //         .where((element) => element.date.year == year.year));
    //     _listYearlyDeaths.add(yearlyAccident);
    //     _yearlyStat.add(YearlyDeaths(i, 0));
    //   }
    //   _listAspectData = _getAspectList(_listAccidentData);
    //   for (var el in _listAspectData) {
    //     int numDead = 0;
    //     for (var i in el) {
    //       numDead += i.numberDead;
    //     }
    //     _deathsSortedByAspect.add(numDead);
    //   }
    //   for (var el in _listAspectData) {
    //     _numIncidentByAspect.add(el.length);
    //   }
    //   int index = 0;
    //   for (var element in _listYearlyDeaths) {
    //     int amountOfDeaths = 0;
    //     for (var el in element) {
    //       amountOfDeaths += el.numberDead;
    //     }
    //     _yearlyStat[index].amountDeaths = amountOfDeaths;
    //     index += 1;
    //   }
    //   _yearlyStat.removeAt(0);
    //
    //   for (var element in _listAccidentData) {
    //     _mapTileLayerController
    //         .insertMarker(_listAccidentData.indexOf(element));
    //   }
    //
    // });
    _mapZoomPanBehavior = MapZoomPanBehavior(
      zoomLevel: 8,
      minZoomLevel: 8,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lawinentote in der Schweiz'),
      ),
      body: FutureBuilder<List<AccidentData>>(
        future: _loadAsset(),
        builder:
            (BuildContext context, AsyncSnapshot<List<AccidentData>> snapshot) {
          if (snapshot.data != null) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  children: [
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: MapView(
                        mapZoomPanBehavior: _mapZoomPanBehavior,
                        listAccidentData: snapshot.data!,
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 0.5,
                      child: YearlyStatView(accidentData: snapshot.data!),
                    ),
                    const StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: Card(
                        elevation: 20,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: DoughnutChart(),
                        ),
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: Card(
                        elevation: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SfCartesianChart(
                              isTransposed: true,
                              series: <ChartSeries>[
                                HistogramSeries<AccidentData, double>(
                                    dataSource: snapshot.data!,
                                    showNormalDistributionCurve: true,
                                    // curveColor: const Color.fromRGBO(192, 108, 132, 1),
                                    binInterval: 200,
                                    yValueMapper: (AccidentData data, _) =>
                                        data.elevation)
                              ]),
                        ),
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: Card(
                        elevation: 20,
                        // child: Column(
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(top: 20.0),
                        //       child: Text('Radar Chart'),
                        //     ),
                        //     Expanded(
                        //       child: RadarChart(
                        //         values: [1, 2, 4, 7, 9, 0, 6, 1, 1, 10, 10, 8, 5, 3, 5, 4],
                        //         labels: const [
                        //           'N',
                        //           'NNO',
                        //           'NO',
                        //           'ONO',
                        //           'O',
                        //           'OSO',
                        //           'SO',
                        //           'SSO',
                        //           'S',
                        //           'SSW',
                        //           'SW',
                        //           'WSW',
                        //           'W',
                        //           'WNW',
                        //           'NW',
                        //           'NNW',
                        //         ],
                        //         maxValue: 10,
                        //         fillColor: Colors.blue,
                        //         chartRadiusFactor: 0.85,
                        //         textScaleFactor: 0.035,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text('Anzahl Tote nach Hanglage'),
                            ),
                            Expanded(
                              child: RadarChart(
                                sides: 0,
                                data: [_deathsSortedByAspect],
                                features: const [
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
                                ],
                                ticks: [10, 20, 30, 40, 50, 60, 70, 80, 90],
                                // maxValue: 10,
                                // fillColor: Colors.blue,
                                // chartRadiusFactor: 0.85,
                                // textScaleFactor: 0.035,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          );
        },
      ),
    );
  }

  Future<List<AccidentData>> _loadAsset() async {
    var result = await rootBundle.loadString(
      "assets/AvalancheAccidents.csv",
    );
    List<List<dynamic>> rowsAsListOfData = const CsvToListConverter()
        .convert(result, eol: "\r", fieldDelimiter: ";");
    rowsAsListOfData.removeAt(0);
    var listAccidentData = <AccidentData>[];
    for (var singleRowAsList in rowsAsListOfData) {
      singleRowAsList[1] = singleRowAsList[1].split('.').reversed.join('-');
      for (var element in singleRowAsList) {
        if (element is String && element == 'NA') {
          singleRowAsList[singleRowAsList.indexOf(element)] = null;
        }
      }
      listAccidentData.add(AccidentData.fromList(singleRowAsList));
    }

    // for (var element in rowsAsListOfData) {
    //   _mapTileLayerController.insertMarker(rowsAsListOfData.indexOf(element));
    // }
    // _processData(listAccidentData);
    // _listAccidentData.addAll(listAccidentData);

    return listAccidentData;
  }

  List<List<AccidentData>> _getAspectList(List<AccidentData> list) {
    List<List<AccidentData>> tempList = [];
    tempList.add(List.from(list.where((element) => element.aspect == 'NN')));
    tempList.add(List.from(list.where((element) => element.aspect == 'NNO')));
    tempList.add(List.from(list.where((element) => element.aspect == 'NO')));
    tempList.add(List.from(list.where((element) => element.aspect == 'ONO')));
    tempList.add(List.from(list.where((element) => element.aspect == 'O')));
    tempList.add(List.from(list.where((element) => element.aspect == 'OSO')));
    tempList.add(List.from(list.where((element) => element.aspect == 'SO')));
    tempList.add(List.from(list.where((element) => element.aspect == 'SSO')));
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

  // void _processData(List<AccidentData> data) {
  //   // _listAccidentData.addAll(data);
  //
  //   for (int i = 1995; i < 2022; i++) {
  //     DateTime year = DateTime(i);
  //     List<AccidentData> yearlyAccident = List.from(
  //         _listAccidentData.where((element) => element.date.year == year.year));
  //     _listYearlyDeaths.add(yearlyAccident);
  //     _yearlyStat.add(YearlyDeaths(i, 0));
  //   }
  //
  //   _listAspectData = _getAspectList(_listAccidentData);
  //   for (var el in _listAspectData) {
  //     int numDead = 0;
  //     for (var i in el) {
  //       numDead += i.numberDead;
  //     }
  //     _deathsSortedByAspect.add(numDead);
  //   }
  //   for (var el in _listAspectData) {
  //     _numIncidentByAspect.add(el.length);
  //   }
  //
  //   // ======
  //   int index = 0;
  //   for (var element in _listYearlyDeaths) {
  //     int amountOfDeaths = 0;
  //     for (var el in element) {
  //       amountOfDeaths += el.numberDead;
  //     }
  //     _yearlyStat[index].amountDeaths = amountOfDeaths;
  //     index += 1;
  //   }
  //   _yearlyStat.removeAt(0);
  //   // =======
  //
  //   // for (var element in _listAccidentData) {
  //   //   _mapTileLayerController.insertMarker(_listAccidentData.indexOf(element));
  //   // }
  // }

}
