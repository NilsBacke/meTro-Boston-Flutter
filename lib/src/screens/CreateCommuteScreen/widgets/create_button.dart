import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/commute.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/CreateCommuteScreen/create_commute_view.dart';
import 'package:mbta_companion/src/screens/CreateCommuteScreen/utils/showUnableDialog.dart';

Widget createButton(
    BuildContext context,
    String appBarText,
    CreateCommuteViewModel viewModel,
    Stop stop1,
    Stop stop2,
    TimeOfDay arrivalTime,
    TimeOfDay departureTime) {
  return Container(
    padding: EdgeInsets.all(12.0),
    child: RaisedButton(
      child: Text(appBarText),
      onPressed: () => createCommute(
          context, viewModel, stop1, stop2, arrivalTime, departureTime),
    ),
  );
}

Future<void> createCommute(
    BuildContext context,
    CreateCommuteViewModel viewModel,
    Stop stop1,
    Stop stop2,
    TimeOfDay arrivalTime,
    TimeOfDay departureTime) async {
  if (stop1 == null || stop2 == null) {
    showUnableToCreateDialog(context);
    return;
  }

  final newCommute = Commute(stop1, stop2, arrivalTime, departureTime);
  viewModel.saveCommute(newCommute);

  Navigator.of(context).pop();
}
