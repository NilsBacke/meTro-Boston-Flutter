import 'package:flutter/material.dart';

showErrorDialog(BuildContext context, String error) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error loading data"),
          content: Text(error),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}
