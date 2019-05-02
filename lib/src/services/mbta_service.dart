import 'dart:async';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import '../models/stop.dart';
import 'dart:convert';

const apiKey = "dc44b30101114e88b45041a4a9b65e06";
const baseURL = "https://api-v3.mbta.com";

class MBTAService {
  // returns a list of the 2 stops that is closest to the given location data
  // will be the same stop, but both directions
  static Future<List<Stop>> getNearestStop(LocationData locationData) async {
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
  static Future<List<Stop>> getNearbyStops(LocationData locationData,
      {double range = 5}) async {
    final radius = range * 0.02;
    final response = await http.get(
        "$baseURL/stops?api_key=$apiKey&filter[latitude]=${locationData.latitude}&filter[longitude]=${locationData.longitude}&filter[radius]=$radius&filter[route_type]=0,1&sort=distance");
    return _jsonToList(response);
  }

  static Future<List<Stop>> getAllStops(LocationData locationData) async {
    return getNearbyStops(locationData, range: 2000);
  }

  static List<Stop> _jsonToList(http.Response response) {
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
