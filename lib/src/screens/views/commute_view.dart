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
      VariablePartTile(
        stops[0].id,
        title: stops[0].name,
        subtitle1: stops[0].lineName,
        otherInfo: [stops[0].directionDescription],
        lineInitials: stops[0].lineInitials,
        lineColor: stops[0].lineColor,
      ),
      VariablePartTile(
        stops[1].id,
        title: stops[1].name,
        subtitle1: stops[1].lineName,
        otherInfo: [stops[1].directionDescription],
        lineInitials: stops[1].lineInitials,
        lineColor: stops[1].lineColor,
      ),
      trailing: Text(
        '$dist mi',
        style: Theme.of(context).textTheme.body2,
      ),
    );
  }

  Widget commuteCard() {
    return threePartCard(
      'Work Commute',
      VariablePartTile(
        "70009",
        title: "Roxbury Crossing",
        subtitle1: "Orange Line",
        otherInfo: ["North towards Oak Grove"],
        lineInitials: "OL",
        lineColor: MBTAColors.orange,
      ),
      VariablePartTile(
        "70009",
        title: "North Station",
        subtitle1: "Orange Line",
        lineInitials: "OL",
        lineColor: MBTAColors.orange,
      ),
      trailing: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget threePartCard(
      String cardTitleText, Widget stopWidget1, Widget stopWidget2,
      {Widget trailing}) {
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
                trailing,
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
