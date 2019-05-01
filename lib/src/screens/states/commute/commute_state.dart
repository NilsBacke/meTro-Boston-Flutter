import 'package:flutter/material.dart';
import 'package:mbta_companion/src/screens/views/commute/commute_view.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';

class CommuteScreen extends StatefulWidget {
  @override
  CommuteView createState() => CommuteView();
}

abstract class CommuteScreenState extends State<CommuteScreen> {
  String data = "no ID";

  @override
  void initState() {
    super.initState();
    LocationService.currentLocation.then((loc) {
      MBTAService.getNearestStop(loc).then((stops) {
        final stop = stops[0];
        final dist = LocationService.getDistance(
            loc.latitude, loc.longitude, stop.latitude, stop.longitude);
        setState(() {
          data = stop.name +
              " - " +
              stop.directionName +
              "bound towards " +
              stop.directionDestination +
              " " +
              dist.toString();
        });
      });
    });
  }
}
