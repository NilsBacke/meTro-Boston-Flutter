// import 'package:location/location.dart';
import 'dart:async';
import 'package:great_circle_distance/great_circle_distance.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:location/location.dart';

class LocationService {
  static Future<LocationData> get currentLocation async {
    return await Location().getLocation();
  }

  static double getDistance(
      double lat1, double long1, double lat2, double long2) {
    var gcd = new GreatCircleDistance.fromDegrees(
        latitude1: lat1, longitude1: long1, latitude2: lat2, longitude2: long2);

    return num.parse((gcd.sphericalLawOfCosinesDistance() * 0.000621371)
        .toStringAsFixed(2)); // to miles
  }

  static Future<double> getDistanceFromStop(Stop stop, LocationData loc) async {
    return LocationService.getDistance(
        stop.latitude, stop.longitude, loc.latitude, loc.longitude);
  }
}
