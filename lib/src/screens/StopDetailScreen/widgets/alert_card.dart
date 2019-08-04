import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/alert.dart';

Widget alertCard(Alert alert, BuildContext context) {
  return Card(
    child: Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: 6.0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 6.0),
                  child: Icon(
                    Icons.warning,
                    color: Colors.yellow,
                  ),
                ),
                Flexible(
                  child: Text(
                    alert.subtitle ?? '',
                    style: TextStyle(fontSize: 18.0, fontFamily: 'Hind'),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Text(alert.description ?? '',
                style: Theme.of(context).textTheme.caption),
          ),
        ],
      ),
    ),
  );
}
