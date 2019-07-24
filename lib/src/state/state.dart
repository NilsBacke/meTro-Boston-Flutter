import 'package:location/location.dart';
import 'package:mbta_companion/src/models/alert.dart';
import 'package:mbta_companion/src/models/commute.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/permission_service.dart';

class AppState {
  final LocationState locationState;
  final NearestStopState nearestStopState;
  final CommuteState commuteState;
  final SavedStopsState savedStopsState;
  final AllStopsState allStopsState;
  final NearbyStopsState nearbyStopsState;
  final AlertsState alertsState;
  final SelectedStopState selectedStopState;

  AppState(
      this.locationState,
      this.nearestStopState,
      this.commuteState,
      this.savedStopsState,
      this.allStopsState,
      this.nearbyStopsState,
      this.alertsState,
      this.selectedStopState);

  factory AppState.initial() => AppState(
      LocationState.initial(),
      NearestStopState.initial(),
      CommuteState.initial(),
      SavedStopsState.initial(),
      AllStopsState.initial(),
      NearbyStopsState.initial(),
      AlertsState.initial(),
      SelectedStopState.initial());
}

class LocationState {
  final LocationData locationData;
  final bool isLocationLoading;
  final LocationStatus locationErrorStatus;

  LocationState(
      this.locationData, this.isLocationLoading, this.locationErrorStatus);

  factory LocationState.initial() => LocationState(null, false, null);
}

class CommuteState {
  final Commute commute;
  final bool isCommuteLoading;
  final String commuteErrorMessage;
  final bool doesCommuteExist;

  CommuteState(this.commute, this.isCommuteLoading, this.commuteErrorMessage,
      this.doesCommuteExist);

  factory CommuteState.initial() => CommuteState(null, false, '', null);
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

class NearestStopState {
  final List<Stop> nearestStop;
  final bool isNearestStopLoading;
  final String nearestStopErrorMessage;

  NearestStopState(this.nearestStop, this.isNearestStopLoading,
      this.nearestStopErrorMessage);

  factory NearestStopState.initial() =>
      NearestStopState(List.unmodifiable([]), false, '');
}

class AlertsState {
  final List<Alert> alerts;
  final bool isAlertsLoading;
  final String alertsErrorMessage;

  AlertsState(this.alerts, this.isAlertsLoading, this.alertsErrorMessage);

  factory AlertsState.initial() =>
      AlertsState(List.unmodifiable([]), false, '');
}

class SelectedStopState {
  final Stop stop;

  SelectedStopState(this.stop);

  factory SelectedStopState.initial() => SelectedStopState(null);
}
