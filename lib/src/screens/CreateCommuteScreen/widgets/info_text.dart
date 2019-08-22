import 'package:flutter/material.dart';

Widget infoText(BuildContext context) {
  return Center(
    child: Container(
      child: Text(
        "Your commute will automatically switch directions based on the time of day.",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.body2,
      ),
    ),
  );
}
