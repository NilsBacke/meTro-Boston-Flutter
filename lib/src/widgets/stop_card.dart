import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/widgets/stop_details_tile.dart';

class StopCard extends StatelessWidget {
  final Stop stop;
  final bool includeDistance;

  /// required if [includeDistance] is true
  final Future<dynamic> distanceFuture;

  StopCard(
      {@required this.stop,
      this.includeDistance = false,
      this.distanceFuture}) {
    if (this.includeDistance) {
      assert(this.distanceFuture != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: this.includeDistance
            ? FutureBuilder(
                future: distanceFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return VariablePartTile(
                    title: stop.name,
                    subtitle1: stop.lineName,
                    otherInfo: [
                      stop.directionDescription,
                      '${snapshot.data} mi'
                    ],
                    lineInitials: stop.lineInitials,
                    lineColor: stop.lineColor,
                  );
                },
              )
            : VariablePartTile(
                title: stop.name,
                subtitle1: stop.lineName,
                otherInfo: [stop.directionDescription],
                lineInitials: stop.lineInitials,
                lineColor: stop.lineColor,
              ),
      ),
    );
  }
}
