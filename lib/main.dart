import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:json_theme/json_theme.dart';
import 'package:swiss_avalanche_dashboard/widgets/aspect_stat_widget.dart';
import 'package:swiss_avalanche_dashboard/widgets/elevation_stat_widget.dart';
import 'package:swiss_avalanche_dashboard/widgets/map_widget.dart';
import 'package:swiss_avalanche_dashboard/widgets/yearly_stat_widget.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

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
      title: 'Statistik - Lawinentote Schweiz',
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

  @override
  void initState() {
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
                      child: ElevationView(accidentData: snapshot.data!),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: AspectView(accidentData: snapshot.data!),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 5,
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

    return listAccidentData;
  }

}
