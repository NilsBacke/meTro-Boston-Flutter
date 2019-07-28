import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/permission_service.dart';
import 'package:mbta_companion/src/widgets/stop_card.dart';

class StopsListView extends StatelessWidget {
  final List<Stop> stops;
  final Function(Stop) onTap;
  final bool dismissable;
  final Function(Stop) onDismiss;
  final bool timeCircles;

  StopsListView(this.stops,
      {this.onTap,
      this.dismissable = false,
      this.onDismiss,
      this.timeCircles = true})
      : assert(dismissable ? onDismiss != null : true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PermissionService.getLocationPermissions(),
      builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
        if (!snapshot.hasData) {
          return StopsLoadingIndicator();
        }
        if (snapshot.data != LocationStatus.granted) {
          return listView(permissionsGranted: false);
        }
        return listView();
      },
    );
  }

  Widget listView({bool permissionsGranted = true}) {
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
              child: stopCard(index, permissionsGranted));
        }
        return stopCard(index, permissionsGranted);
      },
    );
  }

  Widget stopCard(int index, bool permissionsGranted) {
    return StopCard(
      stop: stops[index],
      includeDistance: permissionsGranted,
      distanceFuture: permissionsGranted
          ? LocationService.getDistanceFromStop(stops[index])
          : null,
      onTap: onTap,
      timeCircles: this.timeCircles,
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
