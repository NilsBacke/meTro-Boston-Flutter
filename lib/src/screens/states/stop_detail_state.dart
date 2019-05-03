import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/alert.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/views/stop_detail_view.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';

class StopDetailScreen extends StatefulWidget {
  final Stop stop;
  StopDetailScreen(this.stop);

  @override
  StopDetailScreenView createState() => StopDetailScreenView();
}

abstract class StopDetailScreenState extends State<StopDetailScreen> {
  List<Alert> alerts = List();

  @override
  void initState() {
    super.initState();
    getAlerts(widget.stop);
  }

  Future<void> getAlerts(Stop stop) async {
    final alerts = await MBTAService.fetchAlertsForStop(stopId: stop.id);
    print('Alerts: $alerts');
    if (this.mounted) {
      setState(() {
        this.alerts = alerts;
      });
    }
  }
}
