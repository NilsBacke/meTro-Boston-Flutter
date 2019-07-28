import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/widgets/set_stop_view.dart';

Future<Stop> chooseStop(BuildContext context, bool homeStop,
    {Stop currentStop}) async {
  return await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => SetStopView(
        homeStop,
        (stop) {
          Navigator.of(context).pop(stop);
        },
      ),
    ),
  );
}
