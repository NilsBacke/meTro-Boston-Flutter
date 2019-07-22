import 'package:mbta_companion/src/state/actions/commuteActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<CommuteState> commuteReducer = combineReducers([
  TypedReducer(commuteFetchSuccess),
  TypedReducer(commuteFetchPending),
  TypedReducer(commuteFetchFailure),
]);

CommuteState commuteFetchSuccess(
    CommuteState commuteState, CommuteFetchSuccess action) {
  return CommuteState(action.commute, false, '');
}

CommuteState commuteFetchPending(
    CommuteState commuteState, CommuteFetchPending action) {
  return CommuteState(null, true, '');
}

CommuteState commuteFetchFailure(
    CommuteState commuteState, CommuteFetchFailure action) {
  return CommuteState(null, false, action.commuteErrorMessage);
}
