import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/widgets/direction_timer_column.dart';

Widget twoLinesTimerRow(BuildContext context, Stop stop1, Stop stop2) {
  assert(stop1.lineName == stop2.lineName);

  final Stop firstStop =
      stop1.directionName == "North" || stop1.directionName == "West"
          ? stop1
          : stop2;
  final Stop secondStop =
      stop1.directionName == "North" || stop1.directionName == "West"
          ? stop2
          : stop1;

  return Column(
    children: <Widget>[
      Container(
        child: Center(
          child: Text(
            stop1.lineName,
            style: TextStyle(color: stop1.textColor),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            directionAndTimerColumn(context, firstStop),
            Container(
              margin: EdgeInsets.only(left: 8.0, right: 8.0),
              width: 1.5,
              height: 80.0,
              color: Colors.white30,
            ),
            directionAndTimerColumn(context, secondStop),
          ],
        ),
      ),
    ],
  );
}
