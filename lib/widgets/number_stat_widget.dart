import 'package:flutter/material.dart';

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
    return Card(
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
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        '${snapshot.data}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.headline4?.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.fontSize,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Icon(
                        Custom.christian_cross,
                        color: Colors.white,
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
