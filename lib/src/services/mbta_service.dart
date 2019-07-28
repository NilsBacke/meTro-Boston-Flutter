import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/alert.dart';
import 'package:mbta_companion/src/services/utils/makeRequest.dart';
import '../models/stop.dart';
import 'dart:convert';
import 'utils/executeCall.dart';

class MBTAService {
  static const newAPIURL =
      "https://ad3zbfaf1i.execute-api.us-east-1.amazonaws.com/develop";
  static const awsAPIKey = "q9sdm8YIPS2M8wf3frWic56cqZ4WSIuM4NNnYoKf";
  static const nearestStopRoute = "/stops/nearest/";
  static const nearbyStopsRoute = "/stops/allnearby/";
  static const stopsAtSameLocationRoute = "/stops/location/";
  static const alertsRoute = "/stops/alerts/";
  static const rangeInMiles = 100;
  static const apiKey = 'dc44b30101114e88b45041a4a9b65e06';
  static const baseURL = 'https://api-v3.mbta.com';

  // returns a list of the 2 stops that is closest to the given location data
  // will be the same stop, but both directions
  static Future<List<Stop>> fetchNearestStop(LocationData locationData) async {
    final route =
        "$newAPIURL$nearestStopRoute?latitude=${locationData.latitude}&longitude=${locationData.longitude}";
    final result =
        await makeRequest(Method.GET, route, headers: {"x-api-key": awsAPIKey});

    if (result.hasError) {
      throw new Exception(result.error);
    }

    return _jsonToListOfStops(result.payload);
  }

  // range in miles
  static Future<List<Stop>> fetchNearbyStops(LocationData locationData,
      {int range}) async {
    final route =
        "$newAPIURL$nearbyStopsRoute?latitude=${locationData.latitude}&longitude=${locationData.longitude}" +
            (range != null ? "&range=" + range.toString() : "");
    final result =
        await makeRequest(Method.GET, route, headers: {"x-api-key": awsAPIKey});

    if (result.hasError) {
      throw new Exception(result.error);
    }

    return _jsonToListOfStops(result.payload);
  }

  static Future<List<Stop>> fetchAllStops(LocationData locationData) async {
    return fetchNearbyStops(locationData, range: 2000);
  }

  static Future<List<Stop>> fetchAllStopsAtSameLocation(Stop stop) async {
    final route = "$newAPIURL$stopsAtSameLocationRoute";
    final result = await makeRequest(Method.POST, route,
        headers: {"x-api-key": awsAPIKey}, body: json.encode(stop));

    if (result.hasError) {
      throw new Exception(result.error);
    }

    return _jsonToListOfStops(result);
  }

  static Future<List<Alert>> fetchAlertsForStop(
      {@required String stopId}) async {
    final route = "$newAPIURL/$alertsRoute?stopId=$stopId";
    final result =
        await makeRequest(Method.GET, route, headers: {"x-api-key": awsAPIKey});

    if (result.hasError) {
      throw new Exception(result.error);
    }

    List<Alert> alerts = List();
    for (final alert in result.payload) {
      alerts.add(Alert.fromJson(alert));
    }
    return alerts;
  }

  static List<Stop> _jsonToListOfStops(dynamic jsonData) {
    List<Stop> list = List<Stop>();
    for (final obj in jsonData) {
      list.add(Stop.from(obj));
    }
    return list;
  }
}
