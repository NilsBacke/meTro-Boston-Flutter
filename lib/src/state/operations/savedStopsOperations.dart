import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/saved_stops_service.dart';
import 'package:mbta_companion/src/state/actions/savedStopsActions.dart';
import 'package:mbta_companion/src/utils/report_error.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction fetchSavedStops() {
  return (Store store) async {
    Future(() async {
      store.dispatch(SavedStopsFetchPending());
      try {
        var savedStops = await SavedStopsService.getSavedStops();
        store.dispatch(SavedStopsFetchSuccess(savedStops));
      } catch (e) {
        print("$e");
        store.dispatch(SavedStopsFetchFailure(e.message));
      }
    });
  };
}

ThunkAction addSavedStop(Stop stop) {
  return (Store store) async {
    Future(() async {
      store.dispatch(SavedStopsAddPending());
      try {
        await SavedStopsService.saveStop(stop);
        store.dispatch(SavedStopsAddSuccess(stop));
      } catch (e) {
        print("$e");
        store.dispatch(SavedStopsAddFailure(savedStopsAddErrorMessage));
      }
    });
  };
}

ThunkAction removeSavedStop(Stop stop) {
  return (Store store) async {
    Future(() async {
      try {
        await SavedStopsService.removeStop(stop);
        store.dispatch(SavedStopsRemoveSuccess(stop));
      } catch (e, stackTrace) {
        print("$e");
        store.dispatch(SavedStopsRemoveFailure(savedStopsRemoveErrorMessage));
        reportError(e, stackTrace);
      }
    });
  };
}
