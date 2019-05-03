import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mbta_companion/src/models/alert.dart';
import 'package:mbta_companion/src/screens/states/stop_detail_state.dart';
import 'package:mbta_companion/src/services/location_service.dart';
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
        myLocationEnabled: false,
        markers: [
          Marker(
            markerId: MarkerId(widget.stop.id),
            icon: widget.stop.marker,
            position: coords,
            infoWindow: InfoWindow(
                title: widget.stop.name, snippet: '${widget.stop.lineName}'),
          )
        ].toSet(),
      ),
    );
  }

  Widget bottomHalf() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: ListView.builder(
        itemCount: alerts.length + 2,
        itemBuilder: (context, int i) {
          if (i == 0) {
            return detailsWidget();
          }
          if (alerts.length == 0) {
            return noAlertsWidget();
          }
          return alertCard(alerts[i - 2]);
        },
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
                    Expanded(
                      child: Text(
                        widget.stop.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.directions),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(0.0),
                child: FutureBuilder(
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
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    widget.stop.lineName,
                    style: TextStyle(color: widget.stop.textColor),
                  ),
                ),
              ),
              twoLinesTimerRow(),
              Container(
                child: Text(
                  'Alerts',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget twoLinesTimerRow() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          directionAndTimerColumn(),
          Container(
            margin: EdgeInsets.only(left: 8.0, right: 8.0),
            width: 1.5,
            height: 80.0,
            color: Colors.white30,
          ),
          directionAndTimerColumn(),
        ],
      ),
    );
  }

  Widget directionAndTimerColumn() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              'Northbound',
              style: Theme.of(context).textTheme.body1,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
            child: Text(
              'Oak Grove',
              style: Theme.of(context).textTheme.body2,
            ),
          ),
          TimeCircleCombo(),
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
                      alert.subtitle,
                      style: TextStyle(fontSize: 18.0, fontFamily: 'Hind'),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Text(alert.description,
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
            Icon(
              Icons.tag_faces,
              size: 76.0,
            ),
            Container(
              child: Text('No Alerts'),
            )
          ],
        ),
      ),
    );
  }
}
