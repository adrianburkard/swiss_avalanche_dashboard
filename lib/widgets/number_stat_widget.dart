import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../model/avalanche_accident_data.dart';
import '../presentation/custom_icons.dart';

class NumberView extends StatelessWidget {
  final List<AccidentData> accidentData;
  final String title;
  final int identifier;

  const NumberView({
    Key? key,
    required this.accidentData,
    required this.title,
    required this.identifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 20,
          color: Colors.teal[300],
          child: Center(
            child: FutureBuilder<int>(
              future: _getDeathTotal(accidentData),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '${snapshot.data}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.fontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: identifier == 0
                              ? const Icon(
                                  Custom.christian_cross,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : identifier == 1
                                  ? const FaIcon(
                                      FontAwesomeIcons.personFallingBurst,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : const Icon(
                                      Icons.dangerous,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                        )
                      ],
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
          ),
        ),
        Positioned(
          // will be positioned in the top right of the container
          top: 10,
          right: 10,
          child: Tooltip(
            message: identifier == 0
                ? 'Die Box zeigt die Gesamtanzahl Lawinentote seit 1995.'
                : 'Die Box zeigt die Anzahl Personen, welche von tödlichen \n'
                    'Lawinen mitgerissen wurden seit 1995.',
            child: const Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Future<int> _getDeathTotal(List<AccidentData> data) async {
    int res = 0;

    switch (identifier) {
      case (0):
        for (var el in data) {
          res += el.numberDead;
        }
        break;
      case (1):
        for (var el in data) {
          res += el.numberCaught;
        }
    }

    return res;
  }
}
