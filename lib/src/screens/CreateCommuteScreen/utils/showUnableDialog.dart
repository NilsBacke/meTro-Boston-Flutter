import 'package:flutter/material.dart';

void showUnableToCreateDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Unable to create commute',
            style: Theme.of(context).textTheme.body1,
          ),
          content: Text(
            'Make sure you have both a home and work stop chosen',
            style: Theme.of(context).textTheme.body2,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
