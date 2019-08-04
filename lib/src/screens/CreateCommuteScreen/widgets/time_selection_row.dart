import 'package:flutter/material.dart';
import 'package:mbta_companion/src/screens/CreateCommuteScreen/widgets/time_selector.dart';

Widget timeSelectionRow(BuildContext context, TimeOfDay arrivalTime,
    TimeOfDay departureTime, Function(bool) onPress) {
  return Container(
    padding: EdgeInsets.only(top: 8.0),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        timeSelector(context, arrivalTime, departureTime,
            arrival: true, onPress: onPress),
        Container(
          height: 100.0,
          width: 1.5,
          color: Colors.white30,
          margin: EdgeInsets.only(left: 8.0, right: 8.0),
        ),
        timeSelector(context, arrivalTime, departureTime,
            arrival: false, onPress: onPress),
      ],
    ),
  );
}
