import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;
import 'package:snap_poll/global/global_variables.dart';
class MapImageForLocation extends StatefulWidget {
  const MapImageForLocation({super.key});

  @override
  State<MapImageForLocation> createState() => _MapImageForLocationState();
}

class _MapImageForLocationState extends State<MapImageForLocation> {
  late osm.MapController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = osm.MapController(
      initPosition: osm.GeoPoint(latitude: 49.89873, longitude: 10.90067),
      // areaLimit: BoundingBox(
      //   east: 10.4922941,
      //   north: 47.8084648,
      //   south: 45.817995,
      //   west: 5.9559113,
      // ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: osm.OSMFlutter(
          controller:controller,
          osmOption: osm.OSMOption(
            userTrackingOption: osm.UserTrackingOption(
              enableTracking: true,
              unFollowUser: false,
            ),
            zoomOption: osm.ZoomOption(
              initZoom: 8,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
            userLocationMarker: osm.UserLocationMaker(
              personMarker: osm.MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              directionArrowMarker: osm.MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 48,
                ),
              ),
            ),
          ),
        onMapIsReady: (bool isReady) {
        print("Map is ready: $isReady");
        // if (isReady) {
        //   _addMarkers(GlobalVariables.myMarkers[index]); // Add markers when the map is ready
        // }
      },
      ),
    );
  }

  // Future<void> _addMarkers() async {
  //   await controller.addMarker(
  //     point,
  //     markerIcon: osm.MarkerIcon(
  //       icon: Icon(Icons.location_pin, color: Colors.red, size: 48),
  //     ),
  //   );
  // }
}
