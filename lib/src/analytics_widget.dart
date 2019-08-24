import 'package:flutter/material.dart';
import 'package:amplitude_flutter/amplitude_flutter.dart';

class AnalyticsWidget extends InheritedWidget {
  const AnalyticsWidget({
    Key key,
    @required this.analytics,
    @required Widget child,
  }) : super(key: key, child: child);

  final AmplitudeFlutter analytics;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static AnalyticsWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AnalyticsWidget);
  }
}
