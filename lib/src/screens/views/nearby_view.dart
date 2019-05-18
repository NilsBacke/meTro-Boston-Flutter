import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/widgets/stop_card.dart';
import 'package:mbta_companion/src/widgets/stops_list_view.dart';
import '../states/nearby_state.dart';

class NearbyScreenView extends NearbyScreenState {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(42.353699, -71.067251),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: getNearbyStops(),
          builder: (context, AsyncSnapshot<List<Stop>> snapshot) {
            if (!snapshot.hasData) {
              return StopsLoadingIndicator();
            }
            if (this.noLocationPermissions) {
              return needsPermissions();
            }
            if (this.noLocationService) {
              return needsServices();
            }
            return Column(
              children: <Widget>[
                Expanded(
                  child: topHalf(),
                ),
                Expanded(
                  child: bottomHalf(snapshot.data),
                ),
              ],
            );
          }),
    );
  }

  Container topHalf() {
    return Container(
      child: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        myLocationEnabled: true,
        onMapCreated: (mapscontroller) async {
          controller.complete(mapscontroller);
          final location = await LocationService.currentLocation;
          final GoogleMapController c = await controller.future;
          c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: 15,
          )));
        },
        markers: this.markers.toSet(),
      ),
    );
  }

  Widget bottomHalf(List<Stop> stops) {
    if (stops.length == 0) {
      return Container(
        child: Center(
          child: Text(
            'No stops within ${MBTAService.rangeInMiles} miles',
            style: Theme.of(context).textTheme.body2,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: stops.length,
      itemBuilder: (context, int index) {
        final stop = stops[index];
        return StopCard(
          distanceFuture: LocationService.getDistanceFromStop(stop),
          stop: stop,
          includeDistance: true,
        );
      },
    );
  }

  Widget needsPermissions() {
    return Container(
      child: Center(
        child: Text(
          'Location permissions are not enabled\n\nGo to settings to enable permissions',
          style: Theme.of(context).textTheme.body2,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget needsServices() {
    return Container(
      child: Center(
        child: Text(
          'Location services are not enabled',
          style: Theme.of(context).textTheme.body2,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
