import 'package:location/location.dart';

enum LocationStatus { noPermission, noService, granted }

class PermissionService {
  static Future<LocationStatus> getLocationPermissions() async {
    Location location = new Location();
    final permission = await location.hasPermission();
    final serviceStatus = await location.serviceEnabled();

    if (!permission) {
      return LocationStatus.noPermission;
    }
    if (!serviceStatus) {
      return LocationStatus.noService;
    }
    return LocationStatus.granted;
  }
}
