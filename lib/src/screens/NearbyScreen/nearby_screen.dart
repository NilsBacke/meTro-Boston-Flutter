import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/services/permission_service.dart';
import 'package:mbta_companion/src/state/operations/allStopsOperations.dart';
import 'package:mbta_companion/src/state/operations/locationOperations.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:mbta_companion/src/utils/show_error_dialog.dart';
import 'package:mbta_companion/src/utils/stops_list_helpers.dart';
import 'package:mbta_companion/src/widgets/error_text_widget.dart';
import 'package:mbta_companion/src/widgets/stop_card.dart';
import 'package:mbta_companion/src/widgets/stops_list_view.dart';
import 'package:redux/redux.dart';

class NearbyScreen extends StatefulWidget {
  @override
  _NearbyScreenState createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  Completer<GoogleMapController> controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(42.353699, -71.067251),
    zoom: 14.4746,
  );

  Widget getBodyWidget(_NearbyScreenViewModel viewModel) {
    // error handling
    if (viewModel.locationErrorStatus != null) {
      if (viewModel.locationErrorStatus == LocationStatus.noPermission) {
        return errorTextWidget(context, text: locationPermissionText);
      }

      if (viewModel.locationErrorStatus == LocationStatus.noService) {
        return errorTextWidget(context, text: locationServicesText);
      }
    }

    if (viewModel.allStopsErrorMessage.isNotEmpty) {
      showErrorDialog(context, viewModel.allStopsErrorMessage);
      return errorTextWidget(context, text: viewModel.allStopsErrorMessage);
    }

    // loading
    if (viewModel.isAllStopsLoading || viewModel.isLocationLoading) {
      return StopsLoadingIndicator();
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: topHalf(viewModel.markers),
        ),
        Expanded(
          child: bottomHalf(viewModel.allStops, viewModel.location),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StoreConnector<AppState, _NearbyScreenViewModel>(
          converter: (store) => _NearbyScreenViewModel.create(store),
          builder: (context, _NearbyScreenViewModel viewModel) {
            final bodyWidget = getBodyWidget(viewModel);

            if (viewModel.location == null &&
                !viewModel.isLocationLoading &&
                viewModel.locationErrorStatus == null) {
              viewModel.getLocation();
            }

            if (viewModel.allStops != null &&
                viewModel.allStops.length == 0 &&
                !viewModel.isAllStopsLoading &&
                viewModel.allStopsErrorMessage.isEmpty &&
                viewModel.location != null) {
              viewModel.getAllStops(viewModel.location);
            }
            return bodyWidget;
          }),
    );
  }

  Container topHalf(List<Marker> markers) {
    return Container(
      child: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        myLocationEnabled: true,
        onMapCreated: (mapscontroller) async {
          if (!controller.isCompleted) {
            controller.complete(mapscontroller);
          }
          final location = await LocationService.currentLocation;
          final GoogleMapController c = await controller.future;
          c.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(location.latitude, location.longitude),
            zoom: 15,
          )));
        },
        markers: markers.toSet(),
      ),
    );
  }

  Widget bottomHalf(List<Stop> stops, LocationData locationData) {
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
          location: locationData,
          stop: stop,
          includeDistance: true,
        );
      },
    );
  }
}

class _NearbyScreenViewModel {
  final LocationData location;
  final bool isLocationLoading;
  final LocationStatus locationErrorStatus;
  final List<Stop> allStops;
  final bool isAllStopsLoading;
  final String allStopsErrorMessage;
  final List<Marker> markers;

  final Function() getLocation;
  final Function(LocationData) getAllStops;

  _NearbyScreenViewModel(
      {this.location,
      this.isLocationLoading,
      this.locationErrorStatus,
      this.allStops,
      this.isAllStopsLoading,
      this.allStopsErrorMessage,
      this.getLocation,
      this.getAllStops,
      this.markers});

  factory _NearbyScreenViewModel.create(Store<AppState> store) {
    final state = store.state;

    final List<Marker> markers = [];

    if (state.allStopsState.allStops != null &&
        state.allStopsState.allStops.length != 0 &&
        state.locationState.locationData != null) {
      final consolidatedStops = consolidate(
          state.allStopsState.allStops, state.locationState.locationData);
      for (final Stop stop in consolidatedStops) {
        final double dist = LocationService.getDistanceFromStop(
            stop, state.locationState.locationData);
        markers.add(
          Marker(
            markerId: MarkerId(stop.id),
            position: LatLng(stop.latitude, stop.longitude),
            infoWindow: InfoWindow(
                title: stop.name, snippet: '${stop.lineName} - $dist mi away'),
            icon: stop.marker,
          ),
        );
      }
    }

    return _NearbyScreenViewModel(
        location: state.locationState.locationData,
        isLocationLoading: state.locationState.isLocationLoading,
        locationErrorStatus: state.locationState.locationErrorStatus,
        allStops: state.allStopsState.allStops,
        isAllStopsLoading: state.allStopsState.isAllStopsLoading,
        allStopsErrorMessage: state.allStopsState.allStopsErrorMessage,
        getLocation: () => store.dispatch(fetchLocation()),
        getAllStops: (LocationData locationData) =>
            store.dispatch(fetchAllStops(locationData)),
        markers: markers);
  }
}
