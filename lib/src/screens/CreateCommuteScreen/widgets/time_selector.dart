import 'package:flutter/material.dart';
import 'package:mbta_companion/src/utils/timeofday_helper.dart';

Widget timeSelector(
    BuildContext context, TimeOfDay arrivalTime, TimeOfDay departureTime,
    {@required bool arrival, @required Function(bool) onPress}) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        onPress(arrival);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 6.0),
              child: Icon(
                Icons.access_time,
                size: 30.0,
              ),
            ),
            Text(
              arrival ? "Arrival time at\nwork" : "Departure time from work",
              style: Theme.of(context).textTheme.body2,
              textAlign: TextAlign.center,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                arrival
                    ? TimeOfDayHelper.convertToString(arrivalTime)
                    : TimeOfDayHelper.convertToString(departureTime),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
