import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/states/create_commute_state.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/services/permission_service.dart';
import 'package:mbta_companion/src/utils/timeofday_helper.dart';
import 'package:mbta_companion/src/widgets/commute_time_circle_combo.dart';
import 'package:permission_handler/permission_handler.dart';
import '../states/commute_state.dart';
import '../../widgets/stop_details_tile.dart';

class CommuteView extends CommuteScreenState {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          FutureBuilder(
            future: PermissionService.getLocationPermissions(),
            builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
              if (!snapshot.hasData) {
                return nearbyStopLoadingIndicator();
              }
              if (snapshot.data == LocationStatus.noPermission) {
                return locationPermissionsNotEnabled();
              }
              if (snapshot.data == LocationStatus.noService) {
                return locationServicesNotEnabled();
              }
              return nearbyStopFutureBuilder();
            },
          ),
          this.commute != null ? commuteCard() : emptyCommuteCard(),
        ],
      ),
    );
  }

  Widget nearbyStopFutureBuilder() {
    return FutureBuilder(
      future: getNearestStop(),
      builder: (context, AsyncSnapshot<List<Stop>> snapshot) {
        return snapshot.hasData
            ? nearbyStopCard(snapshot.data)
            : nearbyStopLoadingIndicator();
      },
    );
  }

  Widget nearbyStopLoadingIndicator() {
    return blankNearbyStopCard(
      child: CircularProgressIndicator(
        semanticsLabel: "Loading closest stop",
      ),
    );
  }

  Widget locationPermissionsNotEnabled() {
    return blankNearbyStopCard(
      child: Text(
        'Location permissions are required to view the nearest stop and distances to stops\n\nGo to settings to enable permissions',
        style: Theme.of(context).textTheme.body2,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget locationServicesNotEnabled() {
    return blankNearbyStopCard(
      child: Text(
        'Location services are not enabled',
        style: Theme.of(context).textTheme.body2,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget blankNearbyStopCard({child: Widget}) {
    return Container(
      height: 200.0,
      padding: EdgeInsets.all(2.0),
      child: Card(
        child: Center(child: child == null ? Container() : child),
      ),
    );
  }

  Widget nearbyStopCard(List<Stop> stops) {
    if (stops.length == 0) {
      return blankNearbyStopCard(
        child: Text(
          'No stops within ${MBTAService.rangeInMiles} miles',
          style: Theme.of(context).textTheme.body2,
          textAlign: TextAlign.center,
        ),
      );
    }
    return threePartCard(
      'Nearest Stop',
      GestureDetector(
        onTap: () {
          showDetailForStop(context, stops[0]);
        },
        child: Card(
          elevation: 0.0,
          child: VariablePartTile(
            stops[0].id,
            title: stops[0].name,
            subtitle1: stops[0].lineName,
            otherInfo: [stops[0].directionDescription],
            lineInitials: stops[0].lineInitials,
            lineColor: stops[0].lineColor,
            onTap: () {
              showDetailForStop(context, stops[0]);
            },
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          showDetailForStop(context, stops[1]);
        },
        child: Card(
          elevation: 0.0,
          child: VariablePartTile(
            stops[1].id,
            title: stops[1].name,
            subtitle1: stops[1].lineName,
            otherInfo: [stops[1].directionDescription],
            lineInitials: stops[1].lineInitials,
            lineColor: stops[1].lineColor,
            onTap: () {
              showDetailForStop(context, stops[1]);
            },
          ),
        ),
      ),
      trailing: FutureBuilder(
        future: getDistanceFromNearestStop(stops),
        builder: (context, snapshot) {
          return Text(
            snapshot.hasData ? '${snapshot.data} mi' : '---',
            style: Theme.of(context).textTheme.body2,
          );
        },
      ),
    );
  }

  Widget commuteCard() {
    return threePartCard(
      'Work Commute',
      GestureDetector(
        onTap: () {
          showDetailForStop(context, this.commute.stop1);
        },
        child: Card(
          elevation: 0.0,
          child: VariablePartTile(
            this.commute.stop1.id,
            title: this.commute.stop1.name,
            subtitle1: this.commute.stop1.lineName,
            otherInfo: [this.commute.stop1.directionDescription],
            lineInitials: this.commute.stop1.lineInitials,
            lineColor: this.commute.stop1.lineColor,
            onTap: () {
              showDetailForStop(context, this.commute.stop1);
            },
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          showDetailForStop(context, this.commute.stop2);
        },
        child: Card(
          elevation: 0.0,
          child: VariablePartTile(
            this.commute.stop2.id,
            title: this.commute.stop2.name,
            subtitle1: this.commute.stop2.lineName,
            otherInfo: this.commute.stop2.id == this.commute.workStopId
                ? [TimeOfDayHelper.convertToString(this.commute.arrivalTime)]
                : [],
            lineInitials: this.commute.stop2.lineInitials,
            lineColor: this.commute.stop2.lineColor,
            timeCircles: false,
            trailing: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 8.0, top: 4.0, right: 4.0),
                  child: Text('Arrive at:'),
                ),
                CommuteTimeCircleCombo(this.commute.stop1, this.commute.stop2),
              ],
            ),
          ),
        ),
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
