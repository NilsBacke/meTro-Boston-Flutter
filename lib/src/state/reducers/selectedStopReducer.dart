import 'package:mbta_companion/src/state/actions/selectedStopActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<SelectedStopState> selectedStopReducer = combineReducers([
  TypedReducer(selectStop),
  TypedReducer(deselectStop),
]);

SelectedStopState selectStop(
    SelectedStopState selectedStopState, SelectStop action) {
  return SelectedStopState(action.stop);
}

SelectedStopState deselectStop(
    SelectedStopState selectedStopState, DeselectStop action) {
  return SelectedStopState(null);
}
