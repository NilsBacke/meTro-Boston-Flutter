import 'package:location/location.dart';
import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/state/actions/nearestStopActions.dart';
import 'package:mbta_companion/src/utils/report_error.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction fetchNearestStop(LocationData locationData) {
  return (Store store) async {
    Future(() async {
      store.dispatch(NearestStopFetchPending());
      try {
        var nearestStop = await MBTAService.fetchNearestStop(locationData);
        store.dispatch(NearestStopFetchSuccess(nearestStop));
      } catch (e, stackTrace) {
        print("$e");
        store.dispatch(NearestStopFetchFailure(nearestStopErrorMessage));
        reportError(e, stackTrace);
      }
    });
  };
}
