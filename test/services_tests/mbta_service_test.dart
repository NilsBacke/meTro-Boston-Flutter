import 'package:mbta_companion/src/services/mbta_stream_service.dart';
import 'package:test_api/test_api.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:location/location.dart';

void main() {
  // test("Test getNearestStop", () async {
  //   LocationData loc =
  //       LocationData.fromMap({'latitude': 42.34067, 'longitude': -71.0911});
  //   final stop = await MBTAService.fetchNearestStop(loc);
  //   expect(stop[0].id, '70243');
  //   expect(stop[1].id, '70244');

  //   LocationData loc2 =
  //       LocationData.fromMap({'latitude': 42.3605, 'longitude': -71.0596});
  //   final stop2 = await MBTAService.fetchNearestStop(loc2);
  //   expect(stop2[0].id, '70039');
  //   expect(stop2[1].id, '70040');
  // });

  // test("Test get nearby stops", () async {
  //   LocationData loc =
  //       LocationData.fromMap({'latitude': 42.34067, 'longitude': -71.0911});
  //   final stops = await MBTAService.fetchNearbyStops(loc);
  //   expect(stops[0].id, '70243');
  //   expect(stops[1].id, '70244');
  //   expect(stops[2].id, '70246');
  // });

  // test("Test get predictions for stop", () async {
  //   final durations = await MBTAStreamService.getPredictionsForStopId("70009");
  //   print("Durations: " + durations.toString());
  //   expect(durations.length, 2);
  //   expect(durations[0].length, 3);
  // });
}
