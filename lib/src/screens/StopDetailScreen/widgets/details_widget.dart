import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/alert.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:url_launcher/url_launcher.dart';

Widget detailsWidget(BuildContext context, Stop stop, List<Alert> alerts,
    LocationData locationData) {
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
                      stop.name,
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.directions),
                    onPressed: () => launchMapsUrl(stop),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(0.0),
              child: locationData == null
                  ? Text('')
                  : distanceText(context, stop, locationData),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget distanceText(
    BuildContext context, Stop stop, LocationData locationData) {
  return Text(
    '${LocationService.getDistanceFromStop(stop, locationData)} mi',
    style: Theme.of(context).textTheme.body2,
  );
}

void launchMapsUrl(Stop stop) async {
  final url =
      'https://www.google.com/maps/search/?api=1&query=${stop.latitude},${stop.longitude}';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
