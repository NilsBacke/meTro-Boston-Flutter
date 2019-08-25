import 'package:flutter/material.dart';

Widget emptyNearestStopCard(BuildContext context) {
  return Container(
    child: Container(
      height: 60.0,
      child: Center(
        child: Text(
          "This stop is unidirectional",
          style: TextStyle(color: Colors.white54, fontSize: 20.0),
        ),
      ),
    ),
  );
}
