import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:http/http.dart' as http;
import 'package:mbta_companion/src/utils/timeofday_helper.dart';

class GoogleDistanceService {
  // returns time in minutes
  static Future<int> getTimeBetweenStops(Stop stop1, Stop stop2) async {
    final response = await http.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&mode=transit&origins=${stop1.name}&destinations=${stop2.name}&key=AIzaSyAWdYvAyOYBjqqlTDQCKYCn9psNJkNHR_g");

    print("distance matrix response: ${response.body}");

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
        includeAMPM: false);
  }
}
