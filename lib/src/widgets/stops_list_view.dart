import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/widgets/stop_card.dart';

class StopsListView extends StatelessWidget {
  final List<Stop> stops;

  StopsListView(this.stops);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stops.length,
      itemBuilder: (context, int index) {
        return StopCard(
          stop: stops[index],
          includeDistance: true,
          distanceFuture: LocationService.getDistanceFromStop(stops[index]),
        );
      },
    );
  }
}

class StopsLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
