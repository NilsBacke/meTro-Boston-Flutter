import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/state/actions/locationActions.dart';

fetchLocation(dispatch) async {
  dispatch(LocationFetchPending());
  try {
    var locationData = await LocationService.currentLocation;
    dispatch(LocationFetchSuccess(locationData));
  } catch (e) {
    print("$e");
    dispatch(LocationFetchFailure(e));
  }
}
