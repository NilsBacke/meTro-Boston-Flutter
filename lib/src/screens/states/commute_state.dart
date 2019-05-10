import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/commute.dart';
import 'package:mbta_companion/src/screens/views/commute_view.dart';
import 'package:mbta_companion/src/services/db_service.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'create_commute_state.dart';

class CommuteScreen extends StatefulWidget {
  @override
  CommuteView createState() => CommuteView();
}

abstract class CommuteScreenState extends State<CommuteScreen> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  double dist;
  Commute commute;

  @override
  void initState() {
    Location().requestPermission().then((result) {
      setState(() {});
    });
    getCommute();
    super.initState();
  }

  getNearestStop() {
    return this._memoizer.runOnce(() async {
      final loc = await LocationService.currentLocation;
      final stops = await MBTAService.fetchNearestStop(loc);
      if (stops == null) {
        return null;
      }
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

  Future<void> getCommute() async {
    final commute = await DBService.db.getCommute();
    if (this.mounted) {
      setState(() {
        this.commute = commute;
      });
    }
  }

  Future<void> deleteCommute() async {
    await DBService.db.removeCommute();
    if (this.mounted) {
      setState(() {
        this.commute = null;
      });
    }
  }

  Future<void> editCommute() async {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => CreateCommuteScreen(
                  commute: this.commute,
                ),
          ),
        )
        .then((val) => getCommute());
  }
}
