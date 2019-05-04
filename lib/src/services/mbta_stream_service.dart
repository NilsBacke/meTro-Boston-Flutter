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
    if (jsonData == null) {
      throw 'Jsondata is null: ${response.body}';
    }

    final list = jsonData as List;
    if (list.length == 0) {
      return ["---", "---"];
    }

    try {
      final dataAt0 = jsonData[0];
      times[0] = DateTime.parse(dataAt0['attributes']['arrival_time']);
    } on Exception catch (e) {
      print(e.toString());
      times[0] = null;
    }
    if (list.length == 1) {
      times[1] = null;
    } else {
      try {
        final dataAt1 = jsonData[1];
        times[1] = DateTime.parse(dataAt1['attributes']['arrival_time']);
      } on Exception catch (e) {
        print(e.toString());
        times[1] = null;
      }
    }

    final now = DateTime.now();
    for (final time in times) {
      if (time == null) {
        countDown.add("---");
      } else {
        Duration difference = time.difference(now);
        countDown.add(difference.inMinutes.toString() + "m");
      }
    }

    assert(countDown.length == 2);
    return countDown;
  }
}
