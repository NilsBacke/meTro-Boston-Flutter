import 'package:flutter/material.dart';

Widget errorTextWidget(BuildContext context, {String text}) {
  return Container(
    child: Center(
      child: Text(
        text ?? "No stops found\nTry searching something else",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.body2,
      ),
    ),
  );
}
