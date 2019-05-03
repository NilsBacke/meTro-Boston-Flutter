import 'dart:async';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:mbta_companion/src/models/alert.dart';
import '../models/stop.dart';
import 'dart:convert';

const apiKey = "dc44b30101114e88b45041a4a9b65e06";
const baseURL = "https://api-v3.mbta.com";

class MBTAService {
  // returns a list of the 2 stops that is closest to the given location data
  // will be the same stop, but both directions
  static Future<List<Stop>> fetchNearestStop(LocationData locationData) async {
    List<Stop> list = List<Stop>(2);

    final response = await http.get(
        "$baseURL/stops?api_key=$apiKey&filter[latitude]=${locationData.latitude}&filter[longitude]=${locationData.longitude}&filter[radius]=0.10&filter[route_type]=0,1&sort=distance");
    print("response url: ${response.request.url}");
    final jsonData = json.decode(response.body)['data'];
    list[0] = (Stop.fromJson(jsonData[0]));
    list[1] = (Stop.fromJson(jsonData[1]));
    return list;
  }

  // range in miles
  static Future<List<Stop>> fetchNearbyStops(LocationData locationData,
      {double range = 1}) async {
    final radius = range * 0.02;
    final response = await http.get(
        "$baseURL/stops?api_key=$apiKey&filter[latitude]=${locationData.latitude}&filter[longitude]=${locationData.longitude}&filter[radius]=$radius&filter[route_type]=0,1&sort=distance");
    return _jsonToListOfStops(response);
  }

  static Future<List<Stop>> fetchAllStops(LocationData locationData) async {
    return fetchNearbyStops(locationData, range: 2000);
  }

  static Future<List<Alert>> fetchAlertsForStop({String stopId}) async {
    final response =
        await http.get("$baseURL/alerts?api_key=$apiKey&filter[stop]=$stopId");
    List<Alert> alerts = List();
    final jsonData = json.decode(response.body)['data'];
    if (jsonData == null) {
      throw Exception('Json data is null. Body: ${response.body}');
    }
    for (final obj in jsonData) {
      alerts.add(Alert.fromJson(obj));
    }
    return alerts;
  }

  static List<Stop> _jsonToListOfStops(http.Response response) {
    List<Stop> list = List<Stop>();
    final jsonData = json.decode(response.body)['data'];
    if (jsonData == null) {
      throw Exception('Json data is null. Body: ${response.body}');
    }
    for (final obj in jsonData) {
      list.add(Stop.fromJson(obj));
    }
    return list;
  }
}
