// import 'package:location/location.dart';
import 'dart:async';
import 'package:great_circle_distance/great_circle_distance.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationService {
  static LocationData _currentLocation;

  static Future<LocationData> get currentLocation async {
    if (_currentLocation != null) {
      return _currentLocation;
    }

    final loc = await _loadCurrentLocation();
    _currentLocation = loc;
    return loc;
  }

  static Future<LocationData> _loadCurrentLocation() async {
    // return await Geolocator()
    //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    return await Location().getLocation();
  }

  static double getDistance(
      double lat1, double long1, double lat2, double long2) {
    var gcd = new GreatCircleDistance.fromDegrees(
        latitude1: lat1, longitude1: long1, latitude2: lat2, longitude2: long2);

    return num.parse((gcd.sphericalLawOfCosinesDistance() * 0.000621371)
        .toStringAsFixed(2)); // to miles
  }

  static Future<double> getDistanceFromStop(Stop stop,
      {LocationData loc}) async {
    LocationData currLoc = loc;
    if (currLoc == null) {
      currLoc = await LocationService.currentLocation;
    }
    return LocationService.getDistance(
        stop.latitude, stop.longitude, currLoc.latitude, currLoc.longitude);
  }
}
