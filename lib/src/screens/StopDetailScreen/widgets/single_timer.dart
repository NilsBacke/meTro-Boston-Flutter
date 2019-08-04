import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/widgets/time_circle.dart';

Widget singleTimer(Stop stop) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        padding: EdgeInsets.all(18.0),
        child: Center(
          child: Text(
            stop.lineName,
            style: TextStyle(color: stop.textColor),
          ),
        ),
      ),
      TimeCircleCombo(stop.id),
    ],
  );
}
