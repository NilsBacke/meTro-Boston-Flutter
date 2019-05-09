import 'package:flutter/material.dart';

class TimeOfDayHelper {
  static String convertToString(TimeOfDay time) {
    String minute = time.minute.toString();
    if (time.minute < 10) {
      minute = "0${time.minute}";
    }
    if (time.hour > 12) {
      return '${time.hour - 12}:$minute PM';
    }
    return '${time.hour}:$minute AM';
  }
}
