import 'package:mbta_companion/src/state/actions/locationActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<LocationState> locationDataReducer = combineReducers([
  TypedReducer(locationFetchSuccess),
  TypedReducer(locationFetchPending),
  TypedReducer(locationFetchFailure),
]);

LocationState locationFetchSuccess(
    LocationState locationState, LocationFetchSuccess action) {
  return LocationState(action.locationData, false, null);
}

LocationState locationFetchPending(
    LocationState locationState, LocationFetchPending action) {
  return LocationState(null, true, null);
}

LocationState locationFetchFailure(
    LocationState locationState, LocationFetchFailure action) {
  return LocationState(null, false, action.locationErrorStatus);
}
