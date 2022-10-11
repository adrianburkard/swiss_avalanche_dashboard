import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:json_theme/json_theme.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import 'doughnut_chart.dart';
import 'model/avalanche_accident_data.dart';

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
  late MapShapeSource _mapSource;
  late MapZoomPanBehavior _zoomPanBehavior;
  late MapShapeLayerController _controller;
  late MapShapeSource _dataSource;
  List<AccidentData> _listAccidentData = [];

  @override
  void initState() {
    _mapSource = const MapShapeSource.asset(
      'swissBOUNDARIES3D_1_3_TLM_KANTONSGEBIET.json',
      shapeDataField: 'NAME',
    );

    _loadAsset().then((value) {
      setState(() {
        _listAccidentData.addAll(value);
        _listAccidentData.forEach((element) {

        })
        _controller.insertMarker(0);
        // for (var element in _listAccidentData) {
        //   print(element.toString());
        // }
      });
    });
    _zoomPanBehavior = MapZoomPanBehavior();
    _controller = MapShapeLayerController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lawinentote in der Schweiz'),
        ),
        body: SingleChildScrollView(
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
                  child: Card(
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SfMapsTheme(
                        data: SfMapsThemeData(
                          shapeHoverColor: Colors.transparent,
                          shapeHoverStrokeColor: Theme.of(context).primaryColor,
                          shapeHoverStrokeWidth: 0,
                        ),
                        child: SfMaps(
                          layers: [
                            MapShapeLayer(
                              markerBuilder: (BuildContext context, int index) {
                                return MapMarker(
                                  latitude: _listAccidentData[index].xCoordinate,
                                  longitude: _listAccidentData[index].yCoordinate,
                                  child: Icon(Icons.add_location),
                                );
                              },
                              controller: _controller,
                              initialMarkersCount: 0,

                              zoomPanBehavior: _zoomPanBehavior,
                              color: Colors.transparent,
                              strokeColor: Theme.of(context).primaryColor,
                              strokeWidth: 0.5,
                              source: _mapSource,
                              showDataLabels: false,
                              loadingBuilder: (BuildContext context) {
                                return const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1,
                  child: Card(
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                      child: DoughnutChart(),
                    ),
                  ),
                ),
                StaggeredGridTile.count(
                  crossAxisCellCount: 4,
                  mainAxisCellCount: 2,
                  child: Card(
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DoughnutChart(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        // body: SingleChildScrollView(
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Column(
        //       children: [
        //         Expanded(
        //           child: Row(
        //             children: [
        //               Expanded(
        //                 child: Card(
        //                   elevation: 20,
        //                   child: SfMaps(
        //                     layers: [
        //                       MapShapeLayer(
        //                         source: _mapSource,
        //                         showDataLabels: true,
        //                         strokeColor: Theme.of(context).primaryColor,
        //                         strokeWidth: 0.5,
        //                         dataLabelSettings: MapDataLabelSettings(
        //                             textStyle: TextStyle(
        //                                 color: Colors.black,
        //                                 fontWeight: FontWeight.bold,
        //                                 fontSize: Theme.of(context).textTheme.caption!.fontSize)),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //               Column(
        //                 children: [
        //                   Row(
        //                     children: [
        //                       const Card(
        //                         elevation: 20,
        //                         child: DoughnutChart(),
        //                       ),
        //                       const Card(
        //                         elevation: 20,
        //                         child: DoughnutChart(),
        //                       ),
        //                     ],
        //                   ),
        //                   Row(
        //                     children: [
        //                       const Card(
        //                         elevation: 20,
        //                         child: DoughnutChart(),
        //                       ),
        //                       const Card(
        //                         elevation: 20,
        //                         child: DoughnutChart(),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               )
        //             ],
        //           ),
        //         ),
        //         Row(
        //           children: [
        //             const Card(
        //               elevation: 20,
        //               child: DoughnutChart(),
        //             ),
        //             const Card(
        //               elevation: 20,
        //               child: DoughnutChart(),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }

  Future<List<AccidentData>> _loadAsset() async {
    var result = await rootBundle.loadString(
      "assets/AvalancheAccidents.csv",
    );
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter()
        .convert(result, eol: "\r", fieldDelimiter: ";");
    rowsAsListOfValues.removeAt(0);
    var list = <AccidentData>[];
    for (var singleDataList in rowsAsListOfValues) {
      String dateString = singleDataList[1];
      List<String> dateStringSplit = dateString.split('.');
      singleDataList[1] = dateStringSplit.reversed.join('-');
      for (var element in singleDataList) {
        if (element is String && element == 'NA') {
          singleDataList[singleDataList.indexOf(element)] = null;
        }
      }
      // for (int i = 0; i<16; i++) {
      //   if (i == 0 && singleDataList[i] is! int) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 1 && singleDataList[i] is! DateTime) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 2 && singleDataList[i] is! int) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 3 && singleDataList[i] is! String) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 4 && singleDataList[i] is! String) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 5 && singleDataList[i] is! String) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 6 && singleDataList[i] is! double) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 7 && singleDataList[i] is! double) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 8 && singleDataList[i] is! int) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 9 && singleDataList[i] is! int) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 10 && singleDataList[i] is! String?) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 11 && singleDataList[i] is! int?) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 12 && singleDataList[i] is! int?) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 13 && singleDataList[i] is! int) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 14 && singleDataList[i] is! int) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 15 && singleDataList[i] is! int) print('field: $i of element with id: ${singleDataList[0]}');
      //   if (i == 16 && singleDataList[i] is! String) print('field: $i of element with id: ${singleDataList[0]}');
      // }
      list.add(AccidentData.fromList(singleDataList));
    }

    return list;
  }

}