import 'package:flutter/material.dart';
import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/models/stop.dart';

Widget branchWarning(BuildContext context, Stop stop, {Widget fallback}) {
  return shouldWarn(stop)
      ? Container(
          padding: EdgeInsets.all(12.0),
          child: Text(
            branchWarningMessage,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
        )
      : fallback != null ? fallback : Container();
}

bool shouldWarn(Stop stop) {
  return (stop.lineName == "Red Line" || multiBranchStopList.contains(stop.name)) &&
          stop.directionDestination.contains("&");
}

List<String> multiBranchStopList = ["Kenmore", "Hynes Convention Ctr", "Copley", "Arlington", "Boylston", "Park Street", "Government Center", "Haymarket", "North Station", "Science Park", "Lechmere"];
