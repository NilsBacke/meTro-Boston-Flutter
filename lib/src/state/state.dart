import 'package:location/location.dart';
import 'package:mbta_companion/src/models/commute.dart';
import 'package:mbta_companion/src/models/stop.dart';

class AppState {
  final LocationState locationState;
  final CommuteState commuteState;
  final SavedStopsState savedStopsState;
  final AllStopsState allStopsState;
  final NearbyStopsState nearbyStopsState;

  AppState(this.locationState, this.commuteState, this.savedStopsState,
      this.allStopsState, this.nearbyStopsState);

  factory AppState.initial() => AppState(
      LocationState.initial(),
      CommuteState.initial(),
      SavedStopsState.initial(),
      AllStopsState.initial(),
      NearbyStopsState.initial());
}

class LocationState {
  final LocationData locationData;
  final bool isLocationLoading;
  final String locationErrorMessage;

  LocationState(
      this.locationData, this.isLocationLoading, this.locationErrorMessage);

  factory LocationState.initial() => LocationState(null, false, '');
}

class CommuteState {
  final Commute commute;
  final bool isCommuteLoading;
  final String commuteErrorMessage;

  CommuteState(this.commute, this.isCommuteLoading, this.commuteErrorMessage);

  factory CommuteState.initial() => CommuteState(null, false, '');
}

class SavedStopsState {
  final List<Stop> savedStops;
  final bool isSavedStopsLoading;
  final String savedStopsErrorMessage;

  SavedStopsState(
      this.savedStops, this.isSavedStopsLoading, this.savedStopsErrorMessage);

  factory SavedStopsState.initial() =>
      SavedStopsState(List.unmodifiable([]), false, '');
}

class AllStopsState {
  final List<Stop> allStops;
  final bool isAllStopsLoading;
  final String allStopsErrorMessage;

  AllStopsState(
      this.allStops, this.isAllStopsLoading, this.allStopsErrorMessage);

  factory AllStopsState.initial() =>
      AllStopsState(List.unmodifiable([]), false, '');
}

class NearbyStopsState {
  final List<Stop> nearbyStops;
  final bool isNearbyStopsLoading;
  final String nearbyStopsErrorMessage;

  NearbyStopsState(this.nearbyStops, this.isNearbyStopsLoading,
      this.nearbyStopsErrorMessage);

  factory NearbyStopsState.initial() =>
      NearbyStopsState(List.unmodifiable([]), false, '');
}
