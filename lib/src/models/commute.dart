import 'package:flutter/material.dart';
import 'package:mbta_companion/src/utils/timeofday_helper.dart';

import 'stop.dart';

class Commute {
  String id;
  Stop stop1, stop2;
  TimeOfDay arrivalTime, departureTime;

  Commute(this.stop1, this.stop2, this.arrivalTime, this.departureTime) {
    this.id = "1";
  }

  Commute.fromJson(Map<String, dynamic> parsedJson) {
    this.id = "1";
    this.stop1 = Stop(
        parsedJson['id_one'].toString(),
        parsedJson['name_one'],
        double.parse(parsedJson['latitude_one']),
        double.parse(parsedJson['longitude_one']),
        parsedJson['platform_name_one'],
        parsedJson['direction_name_one'],
        parsedJson['description_one']);
    this.stop2 = Stop(
        parsedJson['id_two'].toString(),
        parsedJson['name_two'],
        double.parse(parsedJson['latitude_two']),
        double.parse(parsedJson['longitude_two']),
        parsedJson['platform_name_two'],
        parsedJson['direction_name_two'],
        parsedJson['description_two']);
    this.arrivalTime = _stringToTimeOfDay(parsedJson['arrival_time']);
    this.departureTime = _stringToTimeOfDay(parsedJson['departure_time']);
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "id_one": this.stop1.id,
        "name_one": this.stop1.name,
        "latitude_one": this.stop1.latitude,
        "longitude_one": this.stop1.longitude,
        "platform_name_one": this.stop1.directionDestination,
        "direction_name_one": this.stop1.directionName,
        "description_one": this.stop1.lineName,
        "id_two": this.stop2.id,
        "name_two": this.stop2.name,
        "latitude_two": this.stop2.latitude,
        "longitude_two": this.stop2.longitude,
        "platform_name_two": this.stop2.directionDestination,
        "direction_name_two": this.stop2.directionName,
        "description_two": this.stop2.lineName,
        "arrival_time": TimeOfDayHelper.convertToString(this.arrivalTime),
        "departure_time": TimeOfDayHelper.convertToString(this.departureTime),
      };

  TimeOfDay _stringToTimeOfDay(String time) {
    String hour = time.substring(0, time.indexOf(":"));
    if (hour[0] == "0") {
      hour = hour[1];
    }
    String minute = time.substring(time.indexOf(":") + 1);
    if (minute[0] == "0") {
      minute = minute[1];
    }
    return TimeOfDay(hour: int.parse(hour), minute: int.parse(minute));
  }
}
