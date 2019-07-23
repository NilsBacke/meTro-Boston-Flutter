import 'package:mbta_companion/src/state/actions/commuteActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<CommuteState> commuteReducer = combineReducers([
  TypedReducer(commuteFetchSuccess),
  TypedReducer(commuteFetchPending),
  TypedReducer(commuteFetchFailure),
  TypedReducer(commuteSaveSuccess),
  TypedReducer(commuteSavePending),
  TypedReducer(commuteSaveFailure),
  TypedReducer(commuteDeleteSuccess),
  TypedReducer(commuteDeletePending),
  TypedReducer(commuteDeleteFailure),
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

CommuteState commuteSaveSuccess(
    CommuteState commuteState, CommuteSaveSuccess action) {
  return CommuteState(action.commute, false, '');
}

CommuteState commuteSavePending(
    CommuteState commuteState, CommuteSavePending action) {
  return CommuteState(null, true, '');
}

CommuteState commuteSaveFailure(
    CommuteState commuteState, CommuteSaveFailure action) {
  return CommuteState(null, false, action.commuteSaveErrorMessage);
}

CommuteState commuteDeleteSuccess(
    CommuteState commuteState, CommuteDeleteSuccess action) {
  return CommuteState(null, false, '');
}

CommuteState commuteDeletePending(
    CommuteState commuteState, CommuteDeletePending action) {
  return CommuteState(null, true, '');
}

CommuteState commuteDeleteFailure(
    CommuteState commuteState, CommuteDeleteFailure action) {
  return CommuteState(null, false, action.commuteDeleteErrorMessage);
}
