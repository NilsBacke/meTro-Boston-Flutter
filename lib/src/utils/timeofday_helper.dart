import 'package:flutter/material.dart';

class TimeOfDayHelper {
  static String convertToString(TimeOfDay time,
      {bool accountForTimeZone = false}) {
    String minute = time.minute.toString();
    int hour = time.hour;

    if (accountForTimeZone) {
      hour = (hour - 4) % 24;
    }

    if (time.minute < 10) {
      minute = "0${time.minute}";
    }
    if (hour > 12) {
      return '${hour - 12}:$minute PM';
    }
    return '$hour:$minute AM';
  }

  /// time1 should be bigger
  static String getDifferenceFormatted(DateTime time1, DateTime time2) {
    int minuteDiff = (time1.minute - time2.minute) % 60;
    int secondDiff = (time1.second - time2.second) % 60;
    if (minuteDiff == 0) {
      return secondDiff.toString() + "s";
    }
    return minuteDiff.toString() + "m";
  }
}
