import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/widgets/stop_card.dart';

class StopsListView extends StatelessWidget {
  final List<Stop> stops;
  final Function(Stop) onTap;
  final bool dismissable;
  final Function(Stop) onDismiss;

  StopsListView(this.stops,
      {this.onTap, this.dismissable = false, this.onDismiss})
      : assert(dismissable ? onDismiss != null : true);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stops.length,
      itemBuilder: (context, int index) {
        if (this.dismissable) {
          return Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(stops[index].id),
            onDismissed: (direction) {
              onDismiss(stops[index]);
            },
            background: Container(
              margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
              color: Colors.red,
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Align(
                  child: Icon(
                    Icons.delete,
                    size: 30.0,
                  ),
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
            child: StopCard(
              stop: stops[index],
              includeDistance: true,
              distanceFuture: LocationService.getDistanceFromStop(stops[index]),
              onTap: onTap,
            ),
          );
        }
        return StopCard(
          stop: stops[index],
          includeDistance: true,
          distanceFuture: LocationService.getDistanceFromStop(stops[index]),
          onTap: onTap,
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
