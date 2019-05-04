import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/views/commute_view.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';

class CommuteScreen extends StatefulWidget {
  @override
  CommuteView createState() => CommuteView();
}

abstract class CommuteScreenState extends State<CommuteScreen> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  double dist;

  @override
  void initState() {
    super.initState();
  }

  getNearestStop() {
    return this._memoizer.runOnce(() async {
      final loc = await LocationService.currentLocation;
      final stops = await MBTAService.fetchNearestStop(loc);
      final stop = stops[0];
      final distVal = LocationService.getDistance(
          loc.latitude, loc.longitude, stop.latitude, stop.longitude);
      if (this.mounted) {
        setState(() {
          this.dist = distVal;
        });
      }
      return stops;
    });
  }
}
