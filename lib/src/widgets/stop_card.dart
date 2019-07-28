import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/widgets/stop_details_tile.dart';

class StopCard extends StatelessWidget {
  final Stop stop;
  final TextOverflow overflow;
  final bool includeDistance;
  final Function(Stop) onTap;
  final bool timeCircles;

  /// required if [includeDistance] is true
  final Future<dynamic> distanceFuture;

  StopCard(
      {@required this.stop,
      this.overflow,
      this.includeDistance = false,
      this.distanceFuture,
      this.onTap,
      this.timeCircles = true}) {
    if (this.includeDistance) {
      assert(this.distanceFuture != null);
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
          child:
              this.includeDistance ? distanceStopCard() : noDistanceStopCard(),
        ),
      ),
    );
  }

  Widget distanceStopCard() {
    return FutureBuilder(
      future: distanceFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return VariablePartTile(
          stop.id,
          title: stop.name,
          subtitle1: stop.lineName,
          otherInfo: [stop.directionDescription, '${snapshot.data} mi'],
          lineInitials: stop.lineInitials,
          lineColor: stop.lineColor,
          overflow: this.overflow,
          timeCircles: this.timeCircles,
        );
      },
    );
  }

  Widget noDistanceStopCard() {
    return VariablePartTile(
      stop.id,
      title: stop.name,
      subtitle1: stop.lineName,
      otherInfo: [stop.directionDescription],
      lineInitials: stop.lineInitials,
      lineColor: stop.lineColor,
      overflow: this.overflow,
      timeCircles: this.timeCircles,
    );
  }

  void showDetail(BuildContext context) {
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => StopDetailScreen(this.stop)));
  }
}
