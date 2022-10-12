import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../model/avalanche_accident_data.dart';
import 'map_pop_up.dart';

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
                    color: Colors.teal,
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
    );
  }
}
