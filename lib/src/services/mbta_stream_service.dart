import 'package:http/http.dart' as http;
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'dart:convert';

class MBTAStreamService {
  static const baseURL = MBTAService.baseURL;
  static const apiKey = MBTAService.apiKey;

  static Future<List<String>> getPredictionsForStopId(String stopId) async {
    List<DateTime> times = List(2);
    List<String> countDown = List();
    final response = await http.get(
        "$baseURL/predictions?api_key=$apiKey&filter[stop]=$stopId&page[limit]=2");
    print("stream response body: " + response.body);
    final jsonData = json.decode(response.body)['data'];
    times[0] = DateTime.parse(jsonData[0]['attributes']['arrival_time']);
    times[1] = DateTime.parse(jsonData[1]['attributes']['arrival_time']);

    final now = DateTime.now();
    for (final time in times) {
      Duration difference = time.difference(now);
      countDown.add(difference.inMinutes.toString() + "m");
    }

    assert(countDown.length <= 2);
    return countDown;
  }
}
