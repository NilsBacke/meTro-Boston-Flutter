import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/states/create_commute_state.dart';
import 'package:mbta_companion/src/utils/mbta_colors.dart';
import 'package:mbta_companion/src/utils/timeofday_helper.dart';
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
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? nearbyStopCard(snapshot.data)
                  : Container(
                      height: 200.0,
                      padding: EdgeInsets.all(2.0),
                      child: Card(
                        child: Center(
                          child: CircularProgressIndicator(
                            semanticsLabel: "Loading closest stop",
                          ),
                        ),
                      ),
                    );
            },
          ),
          this.commute != null ? commuteCard() : emptyCommuteCard(),
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
        this.commute.stop1.id,
        title: this.commute.stop1.name,
        subtitle1: this.commute.stop1.lineName,
        otherInfo: [this.commute.stop1.directionDescription],
        lineInitials: this.commute.stop1.lineInitials,
        lineColor: this.commute.stop1.lineColor,
      ),
      VariablePartTile(
        this.commute.stop2.id,
        title: this.commute.stop2.name,
        subtitle1: this.commute.stop2.lineName,
        otherInfo: [TimeOfDayHelper.convertToString(this.commute.arrivalTime)],
        lineInitials: this.commute.stop2.lineInitials,
        lineColor: this.commute.stop2.lineColor,
      ),
      trailing: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: editCommute,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: showDeleteDialog,
          ),
        ],
      ),
    );
  }

  Widget emptyCommuteCard() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
                MaterialPageRoute(builder: (context) => CreateCommuteScreen()))
            .then((val) => getCommute());
      },
      child: Container(
        height: 200.0,
        child: Card(
          child: Center(
            child: Text(
              "Tap here to create a commute",
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ),
        ),
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

  void showDeleteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Are you sure to want to delete this commute?",
              style: Theme.of(context).textTheme.body1,
            ),
            content: Text("This action cannot be undone."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Delete"),
                onPressed: () async {
                  await deleteCommute();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
