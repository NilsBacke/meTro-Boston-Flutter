import 'package:location/location.dart';

class LocationFetchSuccess {
  final LocationData locationData;

  LocationFetchSuccess(this.locationData);
}

class LocationFetchPending {}

class LocationFetchFailure {
  final String locationErrorMessage;

  LocationFetchFailure(this.locationErrorMessage);
}
