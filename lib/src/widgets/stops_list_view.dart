import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:mbta_companion/src/widgets/stop_card.dart';
import 'package:redux/redux.dart';

class StopsListView extends StatelessWidget {
  final List<Stop> stops;
  final Function(Stop) onTap;
  final bool dismissable;
  final Function(Stop) onDismiss;
  final bool timeCircles;

  StopsListView(this.stops,
      {this.onTap,
      this.dismissable = false,
      this.onDismiss,
      this.timeCircles = true})
      : assert(dismissable ? onDismiss != null : true);

  @override
  Widget build(BuildContext context) {
    // TODO: do we also want to call getLocation()?
    return StoreConnector<AppState, _StopsListViewModel>(
      converter: (store) => _StopsListViewModel.create(store),
      builder: (context, _StopsListViewModel viewModel) {
        return ListView.builder(
          itemCount: stops.length,
          itemBuilder: (context, int index) {
            if (this.dismissable) {
              return Dismissible(
                  direction: DismissDirection.endToStart,
                  key: Key(stops[index].id),
                  onDismissed: (direction) {
                    onDismiss(stops[index]);
                  },
                  background: Container(
                    margin: EdgeInsets.only(top: 6.0, bottom: 6.0),
                    color: Colors.red,
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: Align(
                        child: Icon(
                          Icons.delete,
                          size: 30.0,
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                  child: stopCard(index, viewModel.locationData));
            }
            return stopCard(index, viewModel.locationData);
          },
        );
      },
    );
  }

  Widget stopCard(int index, LocationData locationData) {
    return StopCard(
      stop: stops[index],
      includeDistance: locationData != null,
      distanceFuture: locationData != null
          ? LocationService.getDistanceFromStop(stops[index], locationData)
          : null,
      onTap: onTap,
      timeCircles: this.timeCircles,
    );
  }
}

class StopsLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _StopsListViewModel {
  final LocationData locationData;

  _StopsListViewModel({this.locationData});

  factory _StopsListViewModel.create(Store<AppState> store) {
    final state = store.state;
    return _StopsListViewModel(locationData: state.locationState.locationData);
  }
}
