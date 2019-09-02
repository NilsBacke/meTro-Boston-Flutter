import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/stop_detail_screen.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/widgets/stop_details_tile.dart';

class StopCard extends StatelessWidget {
  final Stop stop;
  final TextOverflow overflow;
  final bool includeDistance;
  final Function(Stop) onTap;
  final bool timeCircles;
  final LocationData location; // required if includeDistance is true
  final bool includeOtherInfo;
  final bool refreshOnScroll;

  StopCard(
      {@required this.stop,
      this.overflow,
      this.includeDistance = false,
      this.onTap,
      this.timeCircles = true,
      this.location,
      this.includeOtherInfo = true,
      this.refreshOnScroll = true}) {
    if (includeDistance) {
      assert(this.location != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap != null ? onTap(this.stop) : showDetail(context);
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.all(12.0),
          child: stopCard(includeDistance, location),
        ),
      ),
    );
  }

  Widget stopCard(bool includeDistance, LocationData location) {
    final List<String> otherInfo = [];
    if (!stop.directionDescription.startsWith("bound") &&
        stop.routeType != RouteType.bus) {
      // end of line stop
      otherInfo.add(stop.directionDescription);
    }

    if (includeDistance) {
      otherInfo
          .add('${LocationService.getDistanceFromStop(stop, location)} mi');
    }

    return VariablePartTile(stop.id,
        title: stop.name,
        subtitle1: stop.lineName,
        otherInfo: this.includeOtherInfo ? otherInfo : [],
        lineInitials: stop.lineInitials,
        lineColor: stop.lineColor,
        overflow: this.overflow,
        timeCircles: this.timeCircles,
        refreshOnScroll: this.refreshOnScroll);
  }

  void showDetail(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => StopDetailScreen(this.stop)));
  }
}
