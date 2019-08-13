import 'package:flutter/material.dart';
import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/models/stop.dart';

Widget branchWarning(BuildContext context, Stop stop, {Widget fallback}) {
  return stop.lineName == "Green Line" &&
          stop.directionDestination.contains("&")
      ? Container(
          padding: EdgeInsets.all(8.0),
          child: Text(
            branchWarningMessage,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.center,
          ),
        )
      : fallback != null ? fallback : Container();
}
