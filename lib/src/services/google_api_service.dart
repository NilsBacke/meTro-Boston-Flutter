import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:http/http.dart' as http;
import 'package:mbta_companion/src/services/utils/executeCall.dart';
import 'package:mbta_companion/src/services/utils/makeRequest.dart';
import 'package:mbta_companion/src/utils/timeofday_helper.dart';

class GoogleAPIService {
  // returns time in minutes
  static Future<int> getTimeBetweenStops(Stop stop1, Stop stop2) async {
    final response = await http.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&mode=transit&origins=${stop1.name} t stop&destinations=${stop2.name} t stop&key=AIzaSyAWdYvAyOYBjqqlTDQCKYCn9psNJkNHR_g");

    final jsonData = json.decode(response.body);
    int seconds;
    try {
      seconds = jsonData['rows'][0]['elements'][0]['duration']['value'];
    } on Exception catch (e) {
      print('Error: ' + e.toString());
      return null;
    }

    return seconds ~/ 60;
  }

  static String getArrivalTime(DateTime time, int minutes) {
    final dateTime = time.add(Duration(minutes: minutes));
    return TimeOfDayHelper.convertToString(TimeOfDay.fromDateTime(dateTime),
        accountForTimeZone: true, includeAMPM: false);
  }

  static List<String> endStops = [
    'Oak Grove',
    'Forest Hills',
    'Alewife',
    'Braintree',
    'Mattapan',
    'Ashmont',
    'Wonderland',
    'Bowdoin',
    'Lechmere',
    'North Station',
    'Government Center',
    'Park Street',
    'Boston College',
    'Cleveland Circle',
    'Riverside',
    'Heath Street'
  ];

  /**
   * Returns the end stop that the train is going towards
   * Returns null if nothing is found
   */
  static Future<String> getDirectionFromRoute(Stop stop1, Stop stop2) async {
    final result = await makeRequest(Method.GET,
        "https://maps.googleapis.com/maps/api/directions/json?origin=${stop1.name} t stop&destination=${stop2.name} t stop&mode=transit&key=AIzaSyAc0KTXVwsaicsJ7f9ggEu6AmIl1JO_BQg");

    if (result.hasError) {
      throw new Exception(result.error);
    }

    // TODO: error handling
    final steps = result.payload['routes'][0]['legs'][0]['steps'];

    for (final step in steps) {
      final String instructionsCase = step['html_instructions'];
      final String instructions = instructionsCase.toLowerCase();
      for (final endStop in endStops) {
        if (instructions.contains(("towards " + endStop).toLowerCase()) &&
            !instructions.contains("walk")) {
          return endStop;
        }
      }
    }

    return null;
  }
}
