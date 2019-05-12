// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'home.dart';

// FirebaseAnalytics analytics = FirebaseAnalytics();

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Boston Subway Companion",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.white,
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 25.0, fontWeight: FontWeight.bold, fontFamily: 'Hind'),
          body1: TextStyle(fontSize: 21.0, fontFamily: 'Hind'),
          body2: TextStyle(
              fontSize: 15.0, fontFamily: 'Hind', color: Colors.white70),
          caption: TextStyle(
              fontSize: 14.0, fontFamily: 'Hind', color: Colors.white54),
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.normal,
          buttonColor: Colors.lightGreen,
        ),
      ),
      home: Home(),
      // navigatorObservers: [
      //   FirebaseAnalyticsObserver(analytics: analytics),
      // ],
    );
  }
}
