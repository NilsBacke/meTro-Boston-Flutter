import 'package:mbta_companion/src/state/actions/operationsActions.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

final Reducer<VehiclesState> vehiclesReducer = combineReducers([
  TypedReducer(vehicleFetchSuccess),
  TypedReducer(vehicleFetchPending),
  TypedReducer(vehicleFetchFailure),
]);

VehiclesState vehicleFetchSuccess(
    VehiclesState vehiclesState, VehiclesFetchSuccess action) {
  return VehiclesState(action.vehicles, false, '');
}

VehiclesState vehicleFetchPending(
    VehiclesState vehiclesState, VehiclesFetchPending action) {
  return VehiclesState(List.unmodifiable([]), true, '');
}

VehiclesState vehicleFetchFailure(
    VehiclesState vehiclesState, VehiclesFetchFailure action) {
  return VehiclesState(
      List.unmodifiable([]), false, action.vehiclesErrorMessage);
}
