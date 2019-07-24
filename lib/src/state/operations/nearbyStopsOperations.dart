import 'package:location/location.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/state/actions/nearbyStopsActions.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction fetchNearbyStops(LocationData locationData) {
  return (Store store) async {
    Future(() async {
      store.dispatch(NearbyStopsFetchPending());
      try {
        var nearbyStops = await MBTAService.fetchNearbyStops(locationData);
        store.dispatch(NearbyStopsFetchSuccess(nearbyStops));
      } catch (e) {
        print("$e");
        store.dispatch(NearbyStopsFetchFailure(e.message));
      }
    });
  };
}
