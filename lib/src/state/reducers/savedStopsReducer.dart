import 'package:mbta_companion/src/state/actions/savedStopsActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<SavedStopsState> savedStopsReducer = combineReducers([
  TypedReducer(savedStopsFetchSuccess),
  TypedReducer(savedStopsFetchPending),
  TypedReducer(savedStopsFetchFailure),
  TypedReducer(addSavedStop),
  TypedReducer(removeSavedStop),
]);

SavedStopsState savedStopsFetchSuccess(
    SavedStopsState savedStopsState, SavedStopsFetchSuccess action) {
  return SavedStopsState(action.stops, false, '');
}

SavedStopsState savedStopsFetchPending(
    SavedStopsState savedStopsState, SavedStopsFetchPending action) {
  return SavedStopsState(
      List.unmodifiable(savedStopsState.savedStops), true, '');
}

SavedStopsState savedStopsFetchFailure(
    SavedStopsState savedStopsState, SavedStopsFetchFailure action) {
  return SavedStopsState(List.unmodifiable(savedStopsState.savedStops), false,
      action.savedStopsErrorMessage);
}

SavedStopsState addSavedStop(
    SavedStopsState savedStopsState, AddSavedStop action) {
  return SavedStopsState(
      List.unmodifiable(savedStopsState.savedStops..add(action.stop)),
      savedStopsState.isSavedStopsLoading,
      savedStopsState.savedStopsErrorMessage);
}

SavedStopsState removeSavedStop(
    SavedStopsState savedStopsState, RemoveSavedStop action) {
  return SavedStopsState(
      List.unmodifiable(savedStopsState.savedStops..remove(action.stop)),
      savedStopsState.isSavedStopsLoading,
      savedStopsState.savedStopsErrorMessage);
}
