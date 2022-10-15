import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../model/avalanche_accident_data.dart';
import 'map_pop_up.dart';

class MapView extends StatefulWidget {
  final List<AccidentData> listAccidentData;

  const MapView({
    Key? key,
    required this.listAccidentData,
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late MapZoomPanBehavior _mapZoomPanBehavior;

  @override
  void initState() {
    _mapZoomPanBehavior = MapZoomPanBehavior(
      zoomLevel: 8,
      minZoomLevel: 8,
      toolbarSettings: const MapToolbarSettings(
        position: MapToolbarPosition.topLeft,
        iconColor: Colors.white,
        itemBackgroundColor: Colors.teal,
        itemHoverColor: Colors.blue,
      ),
    );

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
            child: SfMaps(
              layers: [
                MapTileLayer(
                  urlTemplate: 'https://tile.osm.ch/switzerland/{z}/{x}/{y}.png',
                  initialFocalLatLng: const MapLatLng(46.800663464, 8.222665776),
                  zoomPanBehavior: _mapZoomPanBehavior,
                  initialMarkersCount: widget.listAccidentData.length,
                  markerBuilder: (BuildContext context, int index) {
                    return MapMarker(
                      latitude: widget.listAccidentData[index].yCoordinate,
                      longitude: widget.listAccidentData[index].xCoordinate,
                      child: Icon(
                        Icons.location_pin,
                        size: 24,
                        color: widget.listAccidentData[index].dangerLevel == null
                            ? Colors.white
                            : widget.listAccidentData[index].dangerLevel == 1
                                ? Colors.green
                                : widget.listAccidentData[index].dangerLevel == 2
                                    ? Colors.yellow[500]
                                    : widget.listAccidentData[index].dangerLevel ==
                                            3
                                        ? Colors.orange[700]
                                        : widget.listAccidentData[index]
                                                    .dangerLevel ==
                                                4
                                            ? Colors.red[500]
                                            : Colors.red[900],
                      ),
                    );
                  },
                  tooltipSettings: MapTooltipSettings(
                      color: Theme.of(context).primaryColor,
                      strokeColor: Colors.white,
                      strokeWidth: 1.5),
                  markerTooltipBuilder: (BuildContext context, int index) {
                    return MapPopUp(
                      listAccidentData: widget.listAccidentData,
                      index: index,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const Positioned( // will be positioned in the top right of the container
          top: 16,
          right: 16,
          child: Tooltip(
            message: 'Die Karte zeigt die genauen Standorte der Schadenslawinen. Die \n'
                'Farben entsprechen den herausgegebene Gefahrenstufe an den \n'
                'jeweiligen Ereignistagen. \n'
                'weiss: keine Angabe \n'
                'grün: gering (1) \n'
                'gelb: mässig (2) \n'
                'orange: erheblich (3) \n'
                'hellrot: gross (4) \n'
                'dunkelrot: sehr gross (5)',
            child: Icon(
              Icons.help_outline,
              color: Colors.teal,
            ),
          ),
        ),
      ],
    );
  }
}
