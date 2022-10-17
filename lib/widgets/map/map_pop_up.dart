import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/avalanche_accident_data.dart';

class MapPopUp extends StatelessWidget {
  final List<AccidentData> listAccidentData;
  final int index;

  const MapPopUp(
      {Key? key, required this.listAccidentData, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: listAccidentData[index].locationName.isEmpty
                    ? Text(
                        listAccidentData[index].canton,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .fontSize),
                      )
                    : Text(
                        '${listAccidentData[index].locationName} - ${listAccidentData[index].canton}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .fontSize),
                      ),
              ),
            ],
          ),
          const Divider(
            color: Colors.white,
            height: 10,
            thickness: 1.2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat('dd.MM.yyyy').format(listAccidentData[index].date),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Theme.of(context).textTheme.bodyText2!.fontSize),
              ),
              Text(
                '${listAccidentData[index].elevation} m ü. M.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Theme.of(context).textTheme.bodyText2!.fontSize),
              ),
              Text(
                'Todesopfer: ${listAccidentData[index].numberDead}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Theme.of(context).textTheme.bodyText2!.fontSize),
              ),
              Text(
                'Von Lawine erfasst: ${listAccidentData[index].numberCaught}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Theme.of(context).textTheme.bodyText2!.fontSize),
              ),
              Text(
                'Komplett verschüttet: ${listAccidentData[index].numberFullyBuried}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Theme.of(context).textTheme.bodyText2!.fontSize),
              ),
              listAccidentData[index].aspect != null
                  ? Text(
                      'Hangausrichtung: ${listAccidentData[index].aspect!.replaceAll('E', 'O')}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.bodyText2!.fontSize),
                    )
                  : Text(
                      'Hangausrichtung: k. A.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.bodyText2!.fontSize),
                    ),
              listAccidentData[index].inclination != null
                  ? Text(
                      'Hangneigung: ${listAccidentData[index].inclination}°',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.bodyText2!.fontSize),
                    )
                  : Text(
                      'Hangneigung: k. A.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.bodyText2!.fontSize),
                    ),
              listAccidentData[index].dangerLevel != null
                  ? Text(
                'Gefahrenstufe: ${listAccidentData[index].dangerLevel}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                    Theme.of(context).textTheme.bodyText2!.fontSize),
              )
                  : Text(
                'Gefahrenstufe: k. A.',
                style: TextStyle(
                    color: Colors.white,
                    fontSize:
                    Theme.of(context).textTheme.bodyText2!.fontSize),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
