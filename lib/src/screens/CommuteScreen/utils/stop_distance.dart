import 'package:location/location.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/location_service.dart';

Future<double> getDistanceFromNearestStop(
    LocationData loc, List<Stop> stops) async {
  final stop = stops[0];
  final distVal = LocationService.getDistance(
      loc.latitude, loc.longitude, stop.latitude, stop.longitude);
  return distVal;
}
