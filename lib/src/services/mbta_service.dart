import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/alert.dart';
import 'package:mbta_companion/src/utils/api_request_counter.dart';
import '../models/stop.dart';
import 'dart:convert';

class MBTAService {
  static const newAPIURL =
      "https://ad3zbfaf1i.execute-api.us-east-1.amazonaws.com/develop";
  static const nearestStopRoute = "/stops/nearest/";
  static const nearbyStopsRoute = "/stops/allnearby/";
  static const stopsAtSameLocationRoute = "/stops/location/";
  static const alertsRoute = "/stops/alerts/";
  static const rangeInMiles = 100;

  // returns a list of the 2 stops that is closest to the given location data
  // will be the same stop, but both directions
  static Future<List<Stop>> fetchNearestStop(LocationData locationData) async {
    final response = await http.get(
        "$newAPIURL$nearestStopRoute?latitude=${locationData.latitude}&longitude=${locationData.longitude}");
    print("response url: ${response.request.url}");

    if (APIRequestCounter.debug) {
      APIRequestCounter.incrementCalls('nearest stop');
    }

    final jsonResult = json.decode(response.body);

    if (jsonResult['statusCode'] != 200) {
      print('Error: ' + jsonResult['body']);
      return null;
    }

    final jsonData = jsonResult['body'];

    List<Stop> list = List<Stop>(2);
    list[0] = (Stop.from(jsonData[0]));
    list[1] = (Stop.from(jsonData[1]));
    return list;
  }

  // range in miles
  static Future<List<Stop>> fetchNearbyStops(LocationData locationData,
      {int range}) async {
    final response = await http.get(
        "$newAPIURL$nearbyStopsRoute?latitude=${locationData.latitude}&longitude=${locationData.longitude}" +
            (range != null ? "&range=" + range.toString() : ""));
    print("response url: ${response.request.url}");

    if (APIRequestCounter.debug) {
      APIRequestCounter.incrementCalls('nearby stops');
    }

    // TODO: error handling

    return _jsonToListOfStops(response);
  }

  static Future<List<Stop>> fetchAllStops(LocationData locationData) async {
    return fetchNearbyStops(locationData, range: 2000);
  }

  static Future<List<Stop>> fetchAllStopsAtSameLocation(Stop stop) async {
    final response = await http.post("$newAPIURL$stopsAtSameLocationRoute",
        body: json.encode(stop));

    print("all stops at same location url: ${response.request.url}");

    if (APIRequestCounter.debug) {
      APIRequestCounter.incrementCalls('all stops at same location');
    }

    return _jsonToListOfStops(response);
  }

  static Future<List<Alert>> fetchAlertsForStop(
      {@required String stopId}) async {
    final response = await http.get("$newAPIURL/$alertsRoute?stopId=$stopId");

    if (APIRequestCounter.debug) {
      APIRequestCounter.incrementCalls('alerts');
    }

    List<Alert> alerts = List();
    final jsonData = json.decode(response.body)['body'];
    for (final alert in jsonData) {
      alerts.add(Alert.fromJson(alert));
    }
    return alerts;
  }

  static List<Stop> _jsonToListOfStops(http.Response response) {
    List<Stop> list = List<Stop>();
    final jsonData = json.decode(response.body)['body'];
    if (jsonData == null) {
      throw Exception('Json data is null. Body: ${response.body}');
    }
    for (final obj in jsonData) {
      list.add(Stop.from(obj));
    }
    return list;
  }
}
