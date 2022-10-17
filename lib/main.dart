import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:json_theme/json_theme.dart';
import 'package:swiss_avalanche_dashboard/widgets/activity_stat_widget.dart';
import 'package:swiss_avalanche_dashboard/widgets/aspect_stat_widget.dart';
import 'package:swiss_avalanche_dashboard/widgets/elevation_stat_widget.dart';
import 'package:swiss_avalanche_dashboard/widgets/map/map_widget.dart';
import 'package:swiss_avalanche_dashboard/widgets/number_stat_widget.dart';
import 'package:swiss_avalanche_dashboard/widgets/yearly_stat_widget.dart';
import 'package:swiss_avalanche_dashboard/widgets/danger_stat_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/avalanche_accident_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Lawinentote in der Schweiz (Winter 1995/1996 - Winter 2020/2021)'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info,
              color: Colors.white,
            ),
            tooltip: 'Infos zu den Daten und dem Dashboard.',
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                content: SizedBox(
                  width: 850,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zielsetzung',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge?.fontSize,
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Text(
                        'Wie tödlich sind Lawinen in der Schweiz? Welche Hänge, Höhen und Gefahrenstufe sind hauptverantwortlich für die meisten Todesfälle? Nimmt die Anzahl Lawinentote zu oder ab?',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium?.fontSize,
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        'Lawinen stellen eine grosse Gefahr für Bergsportler- und Bewohner dar. Sie gefährden sowohl Skitourengänger, Schneeschuhläufer und Freerider, wie auch Transportwege oder Gebäude. Um diese Gruppen schützen zu können, sollen vergangene Schadenslawinen analysiert werden. Dabei soll eruiert werden ob bei Schadenslawinen gewisse charakteristisch Merkmale, wie Exposition, Höhe oder Gefahrenstufe, beobachtet werden können. Zudem soll eruiert werden, wie sich die Anzahl Lawinentoten während den Beobachtungsjahren verändert hat. '
                        '\nDas Dashboard soll bei zukünftigen Gefahrensituationen als Hilfe dazu gezogen werden können, um dadurch besonders gefährliche Hänge zu ermitteln. Dies kann sowohl eine Unterstützung bei der Tourenplanung, wie auch bei der Schliessung von Wegen und Strassen sein.',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium?.fontSize,
                        ),
                      ),
                      Container(
                        height: 16,
                      ),
                      Text(
                        'Datengrundlage',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge?.fontSize,
                        ),
                      ),
                      Container(
                        height: 10,
                      ),
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.fontSize,
                          ),
                          text:
                              'Fatal avalanche accidents in Switzerland since 1995-1996. (12. Dezember 2021). Aufgerufen am 10. Oktober 2022 '
                              'bei Envidat: ',
                        ),
                        TextSpan(
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontSize,
                              color: Theme.of(context).primaryColor,
                            ),
                            text:
                                'https://www.envidat.ch/#/metadata/fatal-avalanche-accidents-switzerland-1995',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(Uri.parse(
                                    'https://www.envidat.ch/#/metadata/fatal-avalanche-accidents-switzerland-1995'));
                              })
                      ])),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<AccidentData>>(
        future: _loadAsset(),
        builder:
            (BuildContext context, AsyncSnapshot<List<AccidentData>> snapshot) {
          if (snapshot.data != null) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StaggeredGrid.count(
                  crossAxisCount: 8,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  children: [
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: NumberView(
                        accidentData: snapshot.data!,
                        title: 'Tote insgesamt',
                        identifier: 0,
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: NumberView(
                        accidentData: snapshot.data!,
                        title: 'Personen von tödlichen Lawinen verschüttet',
                        identifier: 1,
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 1,
                      child: YearlyStatView(accidentData: snapshot.data!),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: ActivityView(accidentData: snapshot.data!),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: DangerView(accidentData: snapshot.data!),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 4,
                      mainAxisCellCount: 3,
                      child: MapView(
                        listAccidentData: snapshot.data!,
                      ),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
                      child: ElevationView(accidentData: snapshot.data!),
                    ),
                    StaggeredGridTile.count(
                      crossAxisCellCount: 2,
                      mainAxisCellCount: 2,
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
