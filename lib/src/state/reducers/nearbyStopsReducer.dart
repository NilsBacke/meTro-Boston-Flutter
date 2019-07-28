import 'package:mbta_companion/src/state/actions/nearbyStopsActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<NearbyStopsState> nearbyStopsReducer = combineReducers([
  TypedReducer(nearbyStopsFetchSuccess),
  TypedReducer(nearbyStopsFetchPending),
  TypedReducer(nearbyStopsFetchFailure),
]);

NearbyStopsState nearbyStopsFetchSuccess(
    NearbyStopsState nearbyStopsState, NearbyStopsFetchSuccess action) {
  return NearbyStopsState(action.stops, false, '');
}

NearbyStopsState nearbyStopsFetchPending(
    NearbyStopsState nearbyStopsState, NearbyStopsFetchPending action) {
  return NearbyStopsState(List.unmodifiable([]), true, '');
}

NearbyStopsState nearbyStopsFetchFailure(
    NearbyStopsState nearbyStopsState, NearbyStopsFetchFailure action) {
  return NearbyStopsState(
      List.unmodifiable([]), false, action.nearbyStopsErrorMessage);
}
