import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/stop_detail_screen.dart';

void showDetailForStop(BuildContext context, Stop stop) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => StopDetailScreen(stop)));
}
