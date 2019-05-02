import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/utils/mbta_colors.dart';
import '../states/commute_state.dart';
import '../../widgets/stop_details_tile.dart';

class CommuteView extends CommuteScreenState {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          FutureBuilder(
            future: getNearestStop(),
            builder: (context, AsyncSnapshot<List<Stop>> snapshot) {
              return snapshot.hasData
                  ? nearbyStopCard(snapshot.data)
                  : Container(
                      padding: EdgeInsets.all(12.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          semanticsLabel: "Loading closest stop",
                        ),
                      ),
                    );
            },
          ),
          commuteCard(),
        ],
      ),
    );
  }

  Widget nearbyStopCard(List<Stop> stops) {
    return threePartCard(
      'Nearest Stop',
      ThreePartTile(
        title: stops[0].name,
        subtitle1: stops[0].lineName,
        subtitle2: stops[0].directionDescription,
        lineInitials: stops[0].lineInitials,
        lineColor: stops[0].lineColor,
      ),
      ThreePartTile(
        title: stops[1].name,
        subtitle1: stops[1].lineName,
        subtitle2: stops[1].directionDescription,
        lineInitials: stops[1].lineInitials,
        lineColor: stops[1].lineColor,
      ),
      distanceText: '$dist mi',
    );
  }

  Widget commuteCard() {
    return threePartCard(
        'Work Commute',
        ThreePartTile(
          title: "Roxbury Crossing",
          subtitle1: "Orange Line",
          subtitle2: "North towards Oak Grove",
          lineInitials: "OL",
          lineColor: MBTAColors.orange,
        ),
        TwoPartTile(
          title: "North Station",
          subtitle1: "Orange Line",
          lineInitials: "OL",
          lineColor: MBTAColors.orange,
        ));
  }

  Widget threePartCard(
      String cardTitleText, Widget stopWidget1, Widget stopWidget2,
      {String distanceText = ''}) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  cardTitleText,
                  style: Theme.of(context).textTheme.title,
                ),
                Text(
                  distanceText,
                  style: Theme.of(context).textTheme.body2,
                ),
              ],
            ),
            Divider(),
            stopWidget1,
            Divider(),
            stopWidget2,
          ],
        ),
      ),
    );
  }
}
