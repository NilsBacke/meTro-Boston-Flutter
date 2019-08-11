import 'package:flutter/material.dart';

Widget emptyCard(BuildContext context, bool homeStop, String text,
    Function(bool) onSelectStop) {
  return GestureDetector(
    onTap: () {
      onSelectStop(homeStop);
    },
    child: Container(
      height: 75.0,
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
