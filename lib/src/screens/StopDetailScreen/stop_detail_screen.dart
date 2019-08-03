import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/alert.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/widgets/alert_card.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/widgets/details_widget.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/widgets/no_alerts_widget.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/widgets/single_timer.dart';
import 'package:mbta_companion/src/screens/StopDetailScreen/widgets/two_lines_timer_row.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/state/operations/locationOperations.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:redux/redux.dart';

class StopDetailScreen extends StatefulWidget {
  final Stop stop;

  StopDetailScreen(this.stop);

  @override
  _StopDetailScreenState createState() => _StopDetailScreenState();
}

class _StopDetailScreenState extends State<StopDetailScreen> {
  List<Alert> alerts = List();
  List<Stop> stopsAtLocation = List();

  @override
  void initState() {
    super.initState();
    getAssociatedStops();
    // getAlerts(widget.stop);
  }

  Future<void> getAssociatedStops() async {
    final stops = await MBTAService.fetchAllStopsAtSameLocation(widget.stop);
    if (this.mounted) {
      setState(() {
        this.stopsAtLocation = stops;
      });
    }
  }

  // Future<void> getAlerts(Stop stop) async {
  //   final alerts = await MBTAService.fetchAlertsForStop(stopId: stop.id);
  //   print('Alerts: $alerts');
  //   if (this.mounted) {
  //     setState(() {
  //       this.alerts = alerts;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
    return StoreConnector<AppState, _StopDetailScreenViewModel>(
      converter: (store) => _StopDetailScreenViewModel.create(store),
      builder: (context, _StopDetailScreenViewModel viewModel) {
        if (viewModel.location == null) {
          viewModel.getLocation();
        }

        return Container(
          padding: EdgeInsets.all(12.0),
          child: ListView(
            children: <Widget>[
              detailsWidget(context, widget.stop, alerts, viewModel.location),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: stopsAtLocation.length,
                itemBuilder: (context, int i) {
                  // end of line stop
                  if (stopsAtLocation.length == 1) {
                    return singleTimer(stopsAtLocation[i]);
                  }
                  print("i: $i length: ${stopsAtLocation.length}");
                  if (i % 2 == 0) {
                    return twoLinesTimerRow(
                        context, stopsAtLocation[i], stopsAtLocation[i + 1]);
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
                        return alertCard(alerts[i], context);
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _StopDetailScreenViewModel {
  final LocationData location;

  final Function() getLocation;

  _StopDetailScreenViewModel({this.location, this.getLocation});

  factory _StopDetailScreenViewModel.create(Store<AppState> store) {
    final state = store.state;
    return _StopDetailScreenViewModel(
      location: state.locationState.locationData,
      getLocation: () => store.dispatch(fetchLocation()),
    );
  }
}
