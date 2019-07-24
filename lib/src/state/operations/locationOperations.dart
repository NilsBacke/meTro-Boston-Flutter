import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/permission_service.dart';
import 'package:mbta_companion/src/state/actions/locationActions.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction fetchLocation() {
  return (Store store) async {
    Future(() async {
      store.dispatch(LocationFetchPending());
      try {
        var permissions = await PermissionService.getLocationPermissions();
        if (permissions == LocationStatus.noPermission ||
            permissions == LocationStatus.noService) {
          store.dispatch(LocationFetchFailure(permissions));
          return;
        }

        var locationData = await LocationService.currentLocation;
        store.dispatch(LocationFetchSuccess(locationData));
      } catch (e) {
        print("$e");
        store.dispatch(LocationFetchFailure(LocationStatus.unknown));
      }
    });
  };
}
