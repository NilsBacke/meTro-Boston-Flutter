import 'package:mbta_companion/src/models/stop.dart';

class NearbyStopsFetchSuccess {
  final List<Stop> stops;

  NearbyStopsFetchSuccess(this.stops);
}

class NearbyStopsFetchPending {}

class NearbyStopsFetchFailure {
  final String nearbyStopsErrorMessage;

  NearbyStopsFetchFailure(this.nearbyStopsErrorMessage);
}
