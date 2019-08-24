import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mbta_companion/src/analytics_widget.dart';
import 'package:mbta_companion/src/constants/amplitude_constants.dart';
import 'package:mbta_companion/src/services/config.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'home.dart';
import 'package:mbta_companion/src/state/reducers/reducers.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:amplitude_flutter/amplitude_flutter.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Store<AppState> store = Store<AppState>(appReducer,
      initialState: AppState.initial(),
      middleware: [thunkMiddleware, LoggingMiddleware.printer()]);

  AmplitudeFlutter analytics;

  @override
  void initState() {
    super.initState();
    analytics = AmplitudeFlutter(FIREBASE_STAGE == "prod"
        ? "ef364054c4c835a8073194919dff531e"
        : "e8ba007c0c2c0920314981a652785665");
    analytics.logEvent(name: appStartupAmplitude);
  }

  @override
  Widget build(BuildContext context) {
    return AnalyticsWidget(
      analytics: analytics,
      child: StoreProvider(
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
      ),
    );
  }
}
