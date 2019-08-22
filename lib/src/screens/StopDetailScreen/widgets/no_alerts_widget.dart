import 'package:flutter/material.dart';

Widget noAlertsWidget() {
  return Container(
    child: Center(
      child: Column(
        children: <Widget>[
          IconButton(
            icon: Image.asset(
              "assets/smile.png",
              color: Colors.white,
            ),
            iconSize: 50.0,
            onPressed: null,
          ),
          Container(
            child: Text('No alerts at this time'),
          )
        ],
      ),
    ),
  );
}
