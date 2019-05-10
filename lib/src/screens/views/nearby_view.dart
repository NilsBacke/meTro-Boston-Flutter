import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/widgets/stop_card.dart';
import 'package:mbta_companion/src/widgets/stops_list_view.dart';
import '../states/nearby_state.dart';

class NearbyScreenView extends NearbyScreenState {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(42.34067, -71.0911),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: getNearbyStops(),
          builder: (context, snapshot) {
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
                  child: bottomHalf(),
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
        onMapCreated: (mapscontroller) {
          controller.complete(mapscontroller);
        },
        markers: this.markers.toSet(),
      ),
    );
  }

  ListView bottomHalf() {
    return ListView.builder(
      itemCount: this.stops.length,
      itemBuilder: (context, int index) {
        final stop = this.stops[index];
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
