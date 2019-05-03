import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import '../views/nearby_view.dart';

class NearbyScreen extends StatefulWidget {
  @override
  NearbyScreenView createState() => NearbyScreenView();
}

abstract class NearbyScreenState extends State<NearbyScreen> {
  Completer<GoogleMapController> controller = Completer();
  List<Stop> stops = List();
  List<Marker> markers = List();

  // also sets markers
  Future<List<Stop>> getAllStops() async {
    final loc = await LocationService.currentLocation;
    final stopList = await MBTAService.fetchAllStops(loc);
    this.stops = stopList;

    final List<String> alreadyAddedStopNames = List();

    // set markers
    for (final Stop stop in stopList) {
      if (alreadyAddedStopNames.contains(stop.name)) {
        continue;
      } else {
        alreadyAddedStopNames.add(stop.name);
      }

      final double dist =
          await LocationService.getDistanceFromStop(stop, loc: loc);
      markers.add(
        Marker(
          markerId: MarkerId(stop.id),
          position: LatLng(stop.latitude, stop.longitude),
          infoWindow: InfoWindow(
              title: stop.name, snippet: '${stop.lineName} - $dist mi away'),
          icon: stop.marker,
        ),
      );
    }

    return stopList;
  }

  Future<void> moveCameraTo(Stop stop) async {
    final GoogleMapController c = await controller.future;
    c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(stop.latitude, stop.longitude),
      zoom: 15,
    )));
  }
}
