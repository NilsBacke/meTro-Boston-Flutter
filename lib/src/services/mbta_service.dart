import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/alert.dart';
import 'package:mbta_companion/src/utils/api_request_counter.dart';
import '../models/stop.dart';
import 'dart:convert';

class MBTAService {
  static const apiKey = "dc44b30101114e88b45041a4a9b65e06";
  static const baseURL = "https://api-v3.mbta.com";
  static const rangeInMiles = 100;

  // returns a list of the 2 stops that is closest to the given location data
  // will be the same stop, but both directions
  static Future<List<Stop>> fetchNearestStop(LocationData locationData) async {
    List<Stop> list = List<Stop>(2);

    final radius = 0.02 * rangeInMiles;

    final response = await http.get(
        "$baseURL/stops?api_key=$apiKey&filter[latitude]=${locationData.latitude}&filter[longitude]=${locationData.longitude}&filter[radius]=$radius&filter[route_type]=0,1&sort=distance&page[limit]=2");
    print("response url: ${response.request.url}");

    if (APIRequestCounter.debug) {
      APIRequestCounter.incrementCalls('nearest stop');
    }

    final jsonData = json.decode(response.body)['data'];
    if (jsonData == null || jsonData.length == 0) {
      // error or no stops in area
      return null;
    }

    list[0] = (Stop.fromJson(jsonData[0]));
    list[1] = (Stop.fromJson(jsonData[1]));
    return list;
  }

  // range in miles
  static Future<List<Stop>> fetchNearbyStops(LocationData locationData,
      {int range}) async {
    var response;

    if (range == null) {
      range = rangeInMiles;
    }

    if (locationData == null) {
      // permissions not granted
      response = await http
          .get("$baseURL/stops?api_key=$apiKey&filter[route_type]=0,1");
    } else {
      response = await http.get(
          "$baseURL/stops?api_key=$apiKey&filter[latitude]=${locationData.latitude}&filter[longitude]=${locationData.longitude}&filter[radius]=${range * 0.02}&filter[route_type]=0,1&sort=distance");
    }

    if (APIRequestCounter.debug) {
      APIRequestCounter.incrementCalls('nearby stops');
    }

    return _jsonToListOfStops(response);
  }

  static Future<List<Stop>> fetchAllStops(LocationData locationData) async {
    return fetchNearbyStops(locationData, range: 2000);
  }

  static Future<List<Stop>> fetchAllStopsAtSameLocation(Stop stop) async {
    final response = await http.get(
        "$baseURL/stops?api_key=$apiKey&filter[latitude]=${stop.latitude}&filter[longitude]=${stop.longitude}&filter[radius]=0.01&filter[route_type]=0,1&sort=distance");

    if (APIRequestCounter.debug) {
      APIRequestCounter.incrementCalls('all stops at same location');
    }

    List<Stop> stops = List();
    final jsonData = json.decode(response.body)['data'];
    if (jsonData == null) {
      throw Exception('Json data is null. Body: ${response.body}');
    }
    for (final obj in jsonData) {
      if (obj['attributes']['name'] == stop.name) {
        stops.add(Stop.fromJson(obj));
      }
    }
    stops.sort((stop1, stop2) => stop1.lineName.compareTo(stop2.lineName));
    print('stops: ${stops.toString()}');
    assert(stops.length == 2 || stops.length == 4);
    return stops;
  }

  static Future<List<Alert>> fetchAlertsForStop(
      {@required String stopId}) async {
    final response =
        await http.get("$baseURL/alerts?api_key=$apiKey&filter[stop]=$stopId");

    if (APIRequestCounter.debug) {
      APIRequestCounter.incrementCalls('alerts');
    }

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
