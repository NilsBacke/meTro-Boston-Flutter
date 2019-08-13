import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/utils/branch_warning.dart';
import 'package:mbta_companion/src/widgets/time_circle.dart';

Widget singleTimer(BuildContext context, Stop stop) {
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
      Container(
        child: Text(
          '${stop.directionName}bound',
          style: Theme.of(context).textTheme.body1,
        ),
      ),
      Container(
        padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
        child: Text(
          stop.directionDestination,
          style: Theme.of(context).textTheme.body2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      TimeCircleCombo(stop.id),
      branchWarning(
        context,
        stop,
        fallback: Container(
          height: 30,
        ),
      )
    ],
  );
}
