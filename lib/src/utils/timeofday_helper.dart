import 'package:flutter/material.dart';

class TimeOfDayHelper {
  static String convertToString(TimeOfDay time,
      {bool accountForTimeZone = false, bool includeAMPM = true}) {
    String minute = time.minute.toString();
    int hour = time.hour;

    if (accountForTimeZone) {
      hour = (hour - 4) % 24;
    }

    if (time.minute < 10) {
      minute = "0${time.minute}";
    }
    if (hour > 12) {
      return '${hour - 12}:$minute${includeAMPM ? ' PM' : ''}';
    }
    return '$hour:$minute${includeAMPM ? ' AM' : ''}';
  }

  /// time1 should be bigger
  static String getDifferenceFormatted(DateTime time1, DateTime time2) {
    Duration diff = time1.difference(time2);
    if (diff.isNegative || diff.inSeconds == 0) {
      return "BOARD";
    }

    if (diff.inMinutes == 0) {
      return diff.inSeconds.toString() + "s";
    }
    return diff.inMinutes.toString() + "m";
  }

  static String formatSeconds(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    }
    return '${seconds ~/ 60}m';
  }
}
