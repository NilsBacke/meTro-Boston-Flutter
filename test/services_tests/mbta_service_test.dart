import 'package:test_api/test_api.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:location/location.dart';

void main() {
  test("Test getNearestStop", () async {
    LocationData loc =
        LocationData.fromMap({'latitude': 42.34067, 'longitude': -71.0911});
    final stop = await MBTAService.getNearestStop(loc);
    expect(stop[0].id, '70243');
    expect(stop[1].id, '70244');

    LocationData loc2 =
        LocationData.fromMap({'latitude': 42.3605, 'longitude': -71.0596});
    final stop2 = await MBTAService.getNearestStop(loc2);
    expect(stop2[0].id, '70039');
    expect(stop2[1].id, '70040');
  });

  test("Test get nearby stops", () async {
    LocationData loc =
        LocationData.fromMap({'latitude': 42.34067, 'longitude': -71.0911});
    final stops = await MBTAService.getNearbyStops(loc);
    expect(stops[0].id, '70243');
    expect(stops[1].id, '70244');
    expect(stops[2].id, '70246');
  });
}
