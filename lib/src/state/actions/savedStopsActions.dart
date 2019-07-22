import 'package:mbta_companion/src/models/stop.dart';

class SavedStopsFetchSuccess {
  final List<Stop> stops;

  SavedStopsFetchSuccess(this.stops);
}

class SavedStopsFetchPending {}

class SavedStopsFetchFailure {
  final String savedStopsErrorMessage;

  SavedStopsFetchFailure(this.savedStopsErrorMessage);
}

class AddSavedStop {
  final Stop stop;

  AddSavedStop(this.stop);
}

class RemoveSavedStop {
  final Stop stop;

  RemoveSavedStop(this.stop);
}
