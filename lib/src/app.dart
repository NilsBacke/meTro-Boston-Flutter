// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'home.dart';
import 'package:mbta_companion/src/state/reducers/reducers.dart';
import 'package:redux_logging/redux_logging.dart';

// FirebaseAnalytics analytics = FirebaseAnalytics();

class App extends StatelessWidget {
  final Store<AppState> store = Store<AppState>(appReducer,
      initialState: AppState.initial(),
      middleware: [thunkMiddleware, LoggingMiddleware.printer()]);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: "meTro",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Colors.white,
          textTheme: TextTheme(
            title: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Hind'),
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
      ),
    );
  }
}
