import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/views/commute/commute_view.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';

class CommuteScreen extends StatefulWidget {
  @override
  CommuteView createState() => CommuteView();
}

abstract class CommuteScreenState extends State<CommuteScreen> {
  String dist = '';

  @override
  void initState() {
    super.initState();
  }

  Future<List<Stop>> getNearestStop() async {
    final loc = await LocationService.currentLocation;
    final stops = await MBTAService.getNearestStop(loc);
    final stop = stops[0];
    final dist = LocationService.getDistance(
        loc.latitude, loc.longitude, stop.latitude, stop.longitude);
    setState(() {
      this.dist = '$dist mi';
    });
    return stops;
  }
}
