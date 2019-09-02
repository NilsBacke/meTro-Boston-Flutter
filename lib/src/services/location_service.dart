// import 'package:location/location.dart';
import 'dart:async';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;

class LocationService {
  static Future<LocationData> get currentLocation async {
    return await Location().getLocation();
  }

  static double getDistance(
      double lat1, double long1, double lat2, double long2) {
    return num.parse(_calculateDistance(lat1, long1, lat2, long2)
        .toStringAsFixed(2)); // to miles
  }

  static double getDistanceFromStop(Stop stop, LocationData loc) {
    return LocationService.getDistance(
        stop.latitude, stop.longitude, loc.latitude, loc.longitude);
  }

  static int compareStopDistances(Stop stop1, Stop stop2, LocationData loc) {
    return getDistance(
                stop1.latitude, stop1.longitude, loc.latitude, loc.longitude) >
            getDistance(
                stop2.latitude, stop2.longitude, loc.latitude, loc.longitude)
        ? 1
        : -1;
  }

  static double _calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
