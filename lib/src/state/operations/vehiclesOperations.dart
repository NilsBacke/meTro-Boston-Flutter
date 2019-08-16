import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/state/actions/operationsActions.dart';
import 'package:mbta_companion/src/utils/report_error.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction fetchVehicles() {
  return (Store store) async {
    Future(() async {
      store.dispatch(VehiclesFetchPending());
      try {
        var vehicles = await MBTAService.fetchVehicles();
        store.dispatch(VehiclesFetchSuccess(vehicles));
      } catch (e, stackTrace) {
        print("$e");
        store.dispatch(VehiclesFetchFailure(e.toString()));
        reportError(e, stackTrace);
      }
    });
  };
}
