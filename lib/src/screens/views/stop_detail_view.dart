import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mbta_companion/src/models/alert.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/states/stop_detail_state.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/permission_service.dart';
import 'package:mbta_companion/src/widgets/time_circle.dart';

class StopDetailScreenView extends StopDetailScreenState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stop.name),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: topHalf(),
            ),
            Expanded(
              child: bottomHalf(),
            ),
          ],
        ),
      ),
    );
  }

  Widget topHalf() {
    final coords = LatLng(widget.stop.latitude, widget.stop.longitude);
    return Container(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: coords,
          zoom: 14.4746,
        ),
        myLocationEnabled: true,
        markers: [
          Marker(
            markerId: MarkerId(widget.stop.id),
            icon: widget.stop.marker,
            position: coords,
            infoWindow: InfoWindow(
              title: widget.stop.name,
            ),
          )
        ].toSet(),
      ),
    );
  }

  Widget bottomHalf() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: ListView(
        children: <Widget>[
          detailsWidget(),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: stopsAtLocation.length,
            itemBuilder: (context, int i) {
              if (i % 2 == 0) {
                return twoLinesTimerRow(
                    stopsAtLocation[i], stopsAtLocation[i + 1]);
              }
              return Container();
            },
          ),
          Container(
            child: Text(
              'Alerts:',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          alerts.length == 0
              ? noAlertsWidget()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: alerts.length,
                  itemBuilder: (context, int i) {
                    return alertCard(alerts[i]);
                  },
                ),
        ],
      ),
    );
  }

  Widget detailsWidget() {
    return Column(
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    alerts.length == 0
                        ? Container()
                        : Container(
                            padding: EdgeInsets.only(right: 6.0),
                            child: Tooltip(
                              message: '${alerts.length} Alert(s)',
                              child: Icon(
                                Icons.warning,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                    Expanded(
                      child: Text(
                        widget.stop.name,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.directions),
                      onPressed: launchMapsUrl,
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(0.0),
                child: FutureBuilder(
                  future: PermissionService.getLocationPermissions(),
                  builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data != LocationStatus.granted) {
                      return Text('');
                    }
                    return distanceText();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget distanceText() {
    return FutureBuilder(
      future: LocationService.getDistanceFromStop(widget.stop),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text('');
        }
        return Text(
          '${snapshot.data} mi',
          style: Theme.of(context).textTheme.body2,
        );
      },
    );
  }

  Widget twoLinesTimerRow(Stop stop1, Stop stop2) {
    assert(stop1.lineName == stop2.lineName);

    final Stop firstStop =
        stop1.directionName == "North" || stop1.directionName == "West"
            ? stop1
            : stop2;
    final Stop secondStop =
        stop1.directionName == "North" || stop1.directionName == "West"
            ? stop2
            : stop1;

    return Column(
      children: <Widget>[
        Container(
          child: Center(
            child: Text(
              stop1.lineName,
              style: TextStyle(color: stop1.textColor),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              directionAndTimerColumn(firstStop),
              Container(
                margin: EdgeInsets.only(left: 8.0, right: 8.0),
                width: 1.5,
                height: 80.0,
                color: Colors.white30,
              ),
              directionAndTimerColumn(secondStop),
            ],
          ),
        ),
      ],
    );
  }

  Widget directionAndTimerColumn(Stop stop) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              '${stop.directionName}bound',
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
            child: Text(
              stop.directionDestination,
              style: Theme.of(context).textTheme.body2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TimeCircleCombo(widget.stop.id),
        ],
      ),
    );
  }

  Widget alertCard(Alert alert) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 6.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 6.0),
                    child: Icon(
                      Icons.warning,
                      color: Colors.yellow,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      alert.subtitle ?? '',
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Hind'),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Text(alert.description ?? '',
                  style: Theme.of(context).textTheme.caption),
            ),
          ],
        ),
      ),
    );
  }

  Widget noAlertsWidget() {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Image.asset(
                "assets/smile.png",
                color: Colors.white,
              ),
              iconSize: 50.0,
              onPressed: null,
            ),
            Container(
              child: Text('No alerts at this time'),
            )
          ],
        ),
      ),
    );
  }
}
