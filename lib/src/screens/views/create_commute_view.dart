import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/states/create_commute_state.dart';
import 'package:mbta_companion/src/widgets/stop_card.dart';

class CreateCommuteScreenView extends CreateCommuteScreenState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(appBarText),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  stopContainer(
                      true, "Home", "Tap to add home stop", this.stop1),
                  stopContainer(
                      false, "Work", "Tap to add work stop", this.stop2),
                  timeSelectionRow(),
                ],
              ),
            ),
            infoText(),
            createButton(),
            Container(
              height: 12.0,
            )
          ],
        ),
      ),
    );
  }

  Widget stopContainer(bool homeStop, String title, String body, Stop stop) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          stop == null
              ? emptyCard(homeStop, body)
              : StopCard(
                  stop: stop,
                  timeCircles: false,
                  onTap: (_) {
                    chooseStop(homeStop, currentStop: stop);
                  },
                ),
        ],
      ),
    );
  }

  Widget emptyCard(bool homeStop, String text) {
    return GestureDetector(
      onTap: () => chooseStop(homeStop),
      child: Container(
        height: 100.0,
        child: Card(
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget timeSelectionRow() {
    return Container(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          timeSelector(arrival: true),
          Container(
            height: 100.0,
            width: 1.5,
            color: Colors.white30,
            margin: EdgeInsets.only(left: 8.0, right: 8.0),
          ),
          timeSelector(arrival: false),
        ],
      ),
    );
  }

  Widget timeSelector({@required bool arrival}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          this.pickTime(arrival);
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Icon(
                  Icons.access_time,
                  size: 30.0,
                ),
              ),
              Text(
                arrival ? "Arrival time at\nwork" : "Departure time from work",
                style: Theme.of(context).textTheme.body2,
                textAlign: TextAlign.center,
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Text(arrival ? arrivalTimeString : departureTimeString),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoText() {
    return Center(
      child: Container(
        child: Text(
          "Your commute will automatically switch directions based on the time of day.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body2,
        ),
      ),
    );
  }

  Widget createButton() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: RaisedButton(
        child: Text(appBarText),
        onPressed: createCommute,
      ),
    );
  }
}
