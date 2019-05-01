import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:great_circle_distance/great_circle_distance.dart';

class LocationService {
  static Future<LocationData> get currentLocation async {
    var location = Location();
    var currentLocation;
    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      print("exception: ${e.message}");
      currentLocation = null;
    }
    return currentLocation;
  }

  static double getDistance(
      double lat1, double long1, double lat2, double long2) {
    var gcd = new GreatCircleDistance.fromDegrees(
        latitude1: lat1, longitude1: long1, latitude2: lat2, longitude2: long2);

    return num.parse(
        (gcd.haversineDistance() * 0.000621371).toStringAsFixed(2)); // to miles
  }
}
