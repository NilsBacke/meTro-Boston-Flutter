import 'package:flutter/material.dart';
import 'package:mbta_companion/src/utils/timeofday_helper.dart';
import 'stop.dart';

class Commute {
  String id;
  Stop stop1, stop2;
  TimeOfDay arrivalTime, departureTime;
  String homeStopId, workStopId;

  Commute(this.stop1, this.stop2, this.arrivalTime, this.departureTime) {
    this.id = this.stop1.id + "_" + this.stop2.id;
  }

  Commute.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson['id'];
    this.homeStopId = parsedJson['home_stop_id'];
    this.workStopId = parsedJson['work_stop_id'];
    this.stop1 = Stop.from(parsedJson["stop_one"]);
    this.stop2 = Stop.from(parsedJson["stop_two"]);
    this.arrivalTime = _stringToTimeOfDay(parsedJson['arrival_time']);
    this.departureTime = _stringToTimeOfDay(parsedJson['departure_time']);
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "stop_one": this.stop1.toJson(),
        "stop_two": this.stop2.toJson(),
        "home_stop_id": this.homeStopId,
        "work_stop_id": this.workStopId,
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
    int offset = 0;
    if (minute.contains("AM")) {
      minute = minute.substring(0, minute.length - 3);
    } else if (minute.contains("PM")) {
      minute = minute.substring(0, minute.length - 3);
      offset = 12;
    }
    return TimeOfDay(hour: int.parse(hour) + offset, minute: int.parse(minute));
  }
}
