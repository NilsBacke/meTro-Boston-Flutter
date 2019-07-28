import 'package:flutter/material.dart';
import 'package:mbta_companion/src/screens/CreateCommuteScreen/utils/choose_stop.dart';

Widget emptyCard(BuildContext context, bool homeStop, String text) {
  return GestureDetector(
    onTap: () => chooseStop(context, homeStop),
    child: Container(
      height: 100.0,
      child: Card(
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ),
      ),
    ),
  );
}
