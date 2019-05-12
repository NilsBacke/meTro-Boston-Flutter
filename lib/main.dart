// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'src/app.dart';

void main() {
  // Crashlytics.instance.enableInDevMode = true;

  // // Pass all uncaught errors to Crashlytics.
  // FlutterError.onError = (FlutterErrorDetails details) {
  //   Crashlytics.instance.onError(details);
  // };
  runApp(App());
}
