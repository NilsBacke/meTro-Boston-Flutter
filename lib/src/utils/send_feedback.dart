import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

sendFeedback(BuildContext context) async {
  const url =
      'mailto:nils.backe@gmail.com?subject=Boston Subway Companion Feedback&body=<body>';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Could not open email client"),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }
}
