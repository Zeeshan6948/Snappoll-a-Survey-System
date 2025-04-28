import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart' as osm;
import 'package:get/get.dart';
import 'package:snap_poll/global/colors.dart';
import 'package:snap_poll/global/global_widgets.dart';
import 'package:snap_poll/global/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../global/global_variables.dart';

class OpenStreetMapScreen extends StatefulWidget {
  const OpenStreetMapScreen({super.key});

  @override
  State<OpenStreetMapScreen> createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  osm.GeoPoint? tappedLocation;
  GlobalWidgets globalWidgets = GlobalWidgets();
  late osm.MapController controller;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = osm.MapController(
      initPosition: osm.GeoPoint(latitude: 49.89873, longitude: 10.90067),
    );
    if (kIsWeb) {
      controller.listenerMapSingleTapping.addListener(() async {
        osm.GeoPoint? position = controller.listenerMapSingleTapping.value;
        if (GlobalVariables.myMarkers.length < 3) {
          await controller.addMarker(
            position ?? osm.GeoPoint(latitude: 0.0, longitude: 0.0),
            markerIcon: const osm.MarkerIcon(
              icon: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 48,
              ),
            ),
          );
          setState(() {
            GlobalVariables.myMarkers
                .add(position ?? osm.GeoPoint(latitude: 0.0, longitude: 0.0));
            Map<String, dynamic> map = {
              'latitude': "${position?.latitude}",
              'longitude': "${position?.longitude}",
            };
            GlobalVariables.coordinates.add(map);
          });

          print(
              "Single pressed at: ${position!.latitude}, ${position!.longitude}");
          // _captureScreenshot();
        } else {
          GlobalWidgets.showToast(
              'You can mark three locations only. If you want to mark another one, you have to remove previous ones.');
        }
      });
    } else {
      controller.listenerMapLongTapping.addListener(() async {
        osm.GeoPoint? position = controller.listenerMapLongTapping.value;
        if (GlobalVariables.myMarkers.length < 3) {
          await controller.addMarker(
            position ?? osm.GeoPoint(latitude: 0.0, longitude: 0.0),
            markerIcon: osm.MarkerIcon(
              icon: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 48,
              ),
            ),
          );
          setState(() {
            GlobalVariables.myMarkers
                .add(position ?? osm.GeoPoint(latitude: 0.0, longitude: 0.0));
            Map<String, dynamic> map = {
              'latitude': "${position?.latitude}",
              'longitude': "${position?.longitude}",
            };
            GlobalVariables.coordinates.add(map);
          });
          print(
              "Long pressed at: ${position!.latitude}, ${position!.longitude}");
          // _captureScreenshot();
        } else {
          GlobalWidgets.showToast(
              'You can mark three locations only. If you want to mark another one, you have to remove previous ones.');
        }
      });
    }
  }

  Future<void> _addMarkers() async {
    for (var point in GlobalVariables.myMarkers) {
      await controller.addMarker(
        point,
        markerIcon: osm.MarkerIcon(
          icon: Icon(Icons.location_pin, color: Colors.red, size: 48),
        ),
      );
      print("Added marker at: ${point.latitude}, ${point.longitude}");
    }
  }

  Future<void> _removeMarker(osm.GeoPoint point) async {
    await controller.removeMarker(point);
    setState(() {
      GlobalVariables.myMarkers.remove(point);
      GlobalVariables.coordinates.removeWhere((map) =>
          map['latitude'] == "${point.latitude}" &&
          map['longitude'] == "${point.longitude}");
    });
    print("Removed marker at: ${point.latitude}, ${point.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return ForWeb(context);
    } else {
      return ForMobile(context);
    }
  }

  Widget ForMobile(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          osm.OSMFlutter(
            controller: controller,
            osmOption: osm.OSMOption(
              showDefaultInfoWindow: true,
              showZoomController: true,
              zoomOption: const osm.ZoomOption(
                initZoom: 13,
                maxZoomLevel: 19,
                minZoomLevel: 8,
              ),
              userLocationMarker: osm.UserLocationMaker(
                personMarker: const osm.MarkerIcon(
                  icon:
                      Icon(Icons.location_on, color: ColorsX.blueGradientDark),
                ),
                directionArrowMarker: const osm.MarkerIcon(
                  icon: Icon(
                    Icons.double_arrow,
                    size: 48,
                  ),
                ),
              ),
            ),
            onMapIsReady: (bool isReady) {
              print("Map is ready: $isReady");
              if (isReady) {
                _addMarkers(); // Add markers when the map is ready
              }
            },
            onGeoPointClicked: (osm.GeoPoint point) {
              setState(() {
                tappedLocation = point;
                _removeMarker(point);
              });
              print("Tapped location: ${point.latitude}, ${point.longitude}");
            },
          ),
          GestureDetector(
            onTap: () {
              controller.zoomIn();
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: SizeConfig.screenHeight * .15, right: 10),
                padding: EdgeInsets.all(8),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: ColorsX.white),
                child: Icon(
                  Icons.zoom_in,
                  color: ColorsX.appBarColor,
                  size: 40,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.zoomOut();
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: SizeConfig.screenHeight * .08, right: 10),
                padding: EdgeInsets.all(8),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: ColorsX.white),
                child: Icon(
                  Icons.zoom_out,
                  color: ColorsX.appBarColor,
                  size: 40,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: SizeConfig.screenWidth * .40,
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                ),
                margin: EdgeInsets.only(bottom: 5, right: 10),
                decoration: BoxDecoration(color: ColorsX.appBarColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: ColorsX.white,
                    ),
                    globalWidgets.myText(context, 'Continue to Survey'.tr,
                        ColorsX.white, 0, 0, 0, 0, FontWeight.w600, 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ForWeb(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: osm.OSMFlutter(
              controller: controller,
              osmOption: osm.OSMOption(
                showDefaultInfoWindow: true,
                showZoomController: true,
                zoomOption: const osm.ZoomOption(
                  initZoom: 13,
                  maxZoomLevel: 19,
                  minZoomLevel: 8,
                ),
                userLocationMarker: osm.UserLocationMaker(
                  personMarker: const osm.MarkerIcon(
                    icon: Icon(Icons.location_on,
                        color: ColorsX.blueGradientDark),
                  ),
                  directionArrowMarker: const osm.MarkerIcon(
                    icon: Icon(
                      Icons.double_arrow,
                      size: 48,
                    ),
                  ),
                ),
              ),
              onMapIsReady: (bool isReady) {
                print("Map is ready: $isReady");
                if (isReady) {
                  _addMarkers(); // Add markers when the map is ready
                }
              },
              onGeoPointClicked: (osm.GeoPoint point) {
                setState(() {
                  tappedLocation = point;
                  _removeMarker(point);
                });
                print("Tapped location: ${point.latitude}, ${point.longitude}");
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  controller.zoomIn();
                },
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: SizeConfig.screenHeight * .05,
                    right: 10,
                  ),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorsX.white,
                  ),
                  child: Icon(
                    Icons.zoom_in,
                    color: ColorsX.appBarColor,
                    size: 40,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.zoomOut();
                },
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: SizeConfig.screenHeight * .05,
                    right: 10,
                  ),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorsX.white,
                  ),
                  child: Icon(
                    Icons.zoom_out,
                    color: ColorsX.appBarColor,
                    size: 40,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: SizeConfig.screenWidth * .40,
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  margin: EdgeInsets.only(bottom: 5, right: 10),
                  decoration: BoxDecoration(color: ColorsX.appBarColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: ColorsX.white,
                      ),
                      globalWidgets.myText(
                        context,
                        'Back to the survey'.tr,
                        ColorsX.white,
                        0,
                        0,
                        0,
                        0,
                        FontWeight.w600,
                        16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
