// import 'package:flutter/material.dart';
// import 'package:mbta_companion/src/models/alert.dart';
// import 'package:mbta_companion/src/models/stop.dart';
// import 'package:mbta_companion/src/screens/views/stop_detail_view.dart';
// import 'package:mbta_companion/src/services/mbta_service.dart';
// import 'package:url_launcher/url_launcher.dart';

// class StopDetailScreen extends StatefulWidget {
//   final Stop stop;
//   StopDetailScreen(this.stop);

//   @override
//   StopDetailScreenView createState() => StopDetailScreenView();
// }

// abstract class StopDetailScreenState extends State<StopDetailScreen> {
//   List<Alert> alerts = List();
//   List<Stop> stopsAtLocation = List();

//   @override
//   void initState() {
//     super.initState();
//     getAssociatedStops();
//     getAlerts(widget.stop);
//   }

//   Future<void> getAssociatedStops() async {
//     final stops = await MBTAService.fetchAllStopsAtSameLocation(widget.stop);
//     if (this.mounted) {
//       setState(() {
//         this.stopsAtLocation = stops;
//       });
//     }
//   }

//   Future<void> getAlerts(Stop stop) async {
//     final alerts = await MBTAService.fetchAlertsForStop(stopId: stop.id);
//     print('Alerts: $alerts');
//     if (this.mounted) {
//       setState(() {
//         this.alerts = alerts;
//       });
//     }
//   }

//   void launchMapsUrl() async {
//     final url =
//         'https://www.google.com/maps/search/?api=1&query=${widget.stop.latitude},${widget.stop.longitude}';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }
