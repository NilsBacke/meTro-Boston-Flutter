import 'package:flutter/material.dart';

Widget errorSavedList(BuildContext context, String error) {
  return Container(
    child: Center(
      child: Text(
        error,
        style: Theme.of(context).textTheme.body1,
      ),
    ),
  );
}
