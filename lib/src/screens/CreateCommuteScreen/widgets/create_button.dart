import 'package:flutter/material.dart';

Widget createButton(String appBarText, Function onPress) {
  return Container(
    padding: EdgeInsets.all(12.0),
    child: RaisedButton(child: Text(appBarText), onPressed: onPress),
  );
}
