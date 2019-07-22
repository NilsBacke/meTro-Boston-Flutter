import 'package:mbta_companion/src/state/actions/allStopsActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<AllStopsState> allStopsReducer = combineReducers([
  TypedReducer(allStopsFetchSuccess),
  TypedReducer(allStopsFetchPending),
  TypedReducer(allStopsFetchFailure),
]);

AllStopsState allStopsFetchSuccess(
    AllStopsState allStopsState, AllStopsFetchSuccess action) {
  return AllStopsState(action.stops, false, '');
}

AllStopsState allStopsFetchPending(
    AllStopsState allStopsState, AllStopsFetchPending action) {
  return AllStopsState(null, true, '');
}

AllStopsState allStopsFetchFailure(
    AllStopsState allStopsState, AllStopsFetchFailure action) {
  return AllStopsState(null, false, action.allStopsErrorMessage);
}
