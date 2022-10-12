import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../model/avalanche_accident_data.dart';

class MapView extends StatefulWidget {
  final MapZoomPanBehavior mapZoomPanBehavior;
  final List<AccidentData> listAccidentData;

  const MapView({
    Key? key,
    required this.mapZoomPanBehavior,
    required this.listAccidentData,
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate: 'https://tile.osm.ch/switzerland/{z}/{x}/{y}.png',
              initialFocalLatLng: const MapLatLng(46.800663464, 8.222665776),
              zoomPanBehavior: widget.mapZoomPanBehavior,
              initialMarkersCount: widget.listAccidentData.length,
              markerBuilder: (BuildContext context, int index) {
                return MapMarker(
                  latitude: widget.listAccidentData[index].yCoordinate,
                  longitude: widget.listAccidentData[index].xCoordinate,
                  child: const Icon(
                    Icons.location_pin,
                    size: 24,
                    color: Colors.red,
                  ),
                );
              },
              tooltipSettings: const MapTooltipSettings(
                  color: Colors.blue,
                  strokeColor: Color.fromRGBO(252, 187, 15, 1),
                  strokeWidth: 1.5),
              markerTooltipBuilder: (BuildContext context, int index) {
                return Container(
                  width: 180,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: widget.listAccidentData[index].locationName
                                    .isEmpty
                                ? Text(
                                    widget.listAccidentData[index].canton,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .fontSize),
                                  )
                                : Text(
                                    '${widget.listAccidentData[index].locationName} - ${widget.listAccidentData[index].canton}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .fontSize),
                                  ),
                          ),
                          const Icon(
                            Icons.map,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.white,
                        height: 10,
                        thickness: 1.2,
                      ),
                      Column(
                        children: [
                          Text(
                            'Todesopfer : ${widget.listAccidentData[index].numberDead}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .fontSize),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
