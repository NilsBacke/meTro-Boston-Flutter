import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/analytics_widget.dart';
import 'package:mbta_companion/src/constants/amplitude_constants.dart';
import 'package:mbta_companion/src/models/commute.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/CommuteScreen/widgets/nearest_stop_card.dart';
import 'package:mbta_companion/src/screens/CommuteScreen/widgets/four_part_card.dart';
import 'package:mbta_companion/src/screens/CreateCommuteScreen/create_commute_screen.dart';
import 'package:mbta_companion/src/services/permission_service.dart';
import 'package:mbta_companion/src/state/operations/commuteOperations.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:mbta_companion/src/utils/navigation_utils.dart';
import 'package:mbta_companion/src/utils/show_error_dialog.dart';
import 'package:mbta_companion/src/utils/timeofday_helper.dart';
import 'package:mbta_companion/src/widgets/commute_time_circle_combo.dart';
import 'package:mbta_companion/src/widgets/time_to_walk_text.dart';
import 'package:redux/redux.dart';
import '../../widgets/stop_details_tile.dart';
import 'package:mbta_companion/src/state/operations/locationOperations.dart';

class CommuteScreen extends StatefulWidget {
  @override
  _CommuteScreenState createState() => _CommuteScreenState();
}

class _CommuteScreenState extends State<CommuteScreen> {
  void onInit(_CommuteViewModel viewModel) {
    AnalyticsWidget.of(context)
        .analytics
        .logEvent(name: commuteScreenLoadAmplitude);

    if (viewModel.location == null &&
        !viewModel.isLocationLoading &&
        viewModel.locationErrorStatus == null) {
      viewModel.getLocation();
    }

    if (viewModel.commute == null &&
        !viewModel.isCommuteLoading &&
        viewModel.commuteErrorMessage.length == 0 &&
        (viewModel.commuteExists == null || viewModel.commuteExists == true)) {
      viewModel.getCommute();
    }
  }

  Future onRefresh() async {
    final viewModel = _CommuteViewModel.create(StoreProvider.of(context));
    viewModel.getCommute();
    final nearestViewModel =
        NearestStopViewModel.create(StoreProvider.of(context));
    nearestViewModel.getLocation();
    if (nearestViewModel.location != null) {
      nearestViewModel.getNearestStop(nearestViewModel.location);
    }
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: <Widget>[
            NearestStopCard(),
            StoreConnector<AppState, _CommuteViewModel>(
              onInit: (store) => this.onInit(_CommuteViewModel.create(store)),
              converter: (store) => _CommuteViewModel.create(store),
              builder: (context, _CommuteViewModel viewModel) {
                if (viewModel.commuteErrorMessage.length != 0) {
                  Future.delayed(
                    Duration.zero,
                    () =>
                        showErrorDialog(context, viewModel.commuteErrorMessage),
                  );
                  return commuteCardWithText(viewModel.commuteErrorMessage);
                }

                if (viewModel.isCommuteLoading) {
                  return loadingCommuteCard();
                }

                if (viewModel.commute == null &&
                    viewModel.commuteErrorMessage == '') {
                  return emptyCommuteCard(context, viewModel);
                }

                return commuteCard(context, viewModel);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget commuteCard(context, _CommuteViewModel viewModel) {
    final List<String> otherInfo = [];

    if (!viewModel.commute.stop1.directionDescription.startsWith("bound")) {
      otherInfo.add(viewModel.commute.stop1.directionDescription);
    }

    return FourPartCard(
      'Work Commute',
      GestureDetector(
        onTap: () {
          showDetailForStop(context, viewModel.commute.stop1);
        },
        child: Card(
          elevation: 0.0,
          child: VariablePartTile(
            viewModel.commute.stop1.id,
            title: viewModel.commute.stop1.name,
            subtitle1: viewModel.commute.stop1.lineName,
            otherInfo: otherInfo,
            lineInitials: viewModel.commute.stop1.lineInitials,
            lineColor: viewModel.commute.stop1.lineColor,
            onTap: () {
              showDetailForStop(context, viewModel.commute.stop1);
            },
            refreshOnScroll: false,
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          showDetailForStop(context, viewModel.commute.stop2);
        },
        child: Card(
          elevation: 0.0,
          child: VariablePartTile(
            viewModel.commute.stop2.id,
            title: viewModel.commute.stop2.name,
            subtitle1: viewModel.commute.stop2.lineName,
            otherInfo:
                viewModel.commute.stop2.id == viewModel.commute.workStopId
                    ? [
                        TimeOfDayHelper.convertToString(
                            viewModel.commute.arrivalTime)
                      ]
                    : [],
            lineInitials: viewModel.commute.stop2.lineInitials,
            lineColor: viewModel.commute.stop2.lineColor,
            timeCircles: false,
            trailing: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 8.0, top: 4.0, right: 4.0),
                  child: Text('Arrive at:'),
                ),
                CommuteTimeCircleCombo(
                    viewModel.commute.stop1, viewModel.commute.stop2),
              ],
            ),
            refreshOnScroll: false,
          ),
        ),
      ),
      timeToWalkText(context, viewModel.commute.stop1, viewModel.location),
      trailing: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => editCommute(context, viewModel),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => showDeleteDialog(context, viewModel),
          ),
        ],
      ),
    );
  }

  Widget loadingCommuteCard() {
    return Container(
      height: 200.0,
      child: Card(
        child: Center(
          child: CircularProgressIndicator(
            semanticsLabel: "Loading your commute",
          ),
        ),
      ),
    );
  }

  Widget emptyCommuteCard(context, _CommuteViewModel viewModel) {
    return GestureDetector(
        onTap: () => editCommute(context, viewModel),
        child: commuteCardWithText("Tap here to create a commute"));
  }

  Widget commuteCardWithText(String text) {
    return Container(
      height: 200.0,
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
    );
  }

  Future<void> editCommute(context, _CommuteViewModel viewModel) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateCommuteScreen(),
      ),
    );
  }

  void showDeleteDialog(context, _CommuteViewModel viewModel) {
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
                viewModel.deleteCommute(viewModel.commute);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _CommuteViewModel {
  final LocationData location;
  final bool isLocationLoading;
  final LocationStatus locationErrorStatus;
  final Commute commute;
  final bool isCommuteLoading;
  final String commuteErrorMessage;
  final bool commuteExists;

  final Function() getLocation;
  final Function() getCommute;
  final Function(Commute) saveCommute;
  final Function(Commute) deleteCommute;

  _CommuteViewModel(
      {this.location,
      this.isLocationLoading,
      this.locationErrorStatus,
      this.commute,
      this.isCommuteLoading,
      this.commuteErrorMessage,
      this.commuteExists,
      this.getCommute,
      this.saveCommute,
      this.deleteCommute,
      this.getLocation});

  factory _CommuteViewModel.create(Store<AppState> store) {
    final state = store.state;
    return _CommuteViewModel(
        location: state.locationState.locationData,
        isLocationLoading: state.locationState.isLocationLoading,
        locationErrorStatus: state.locationState.locationErrorStatus,
        commute: reverseCommuteIfNecessary(state.commuteState.commute),
        isCommuteLoading: state.commuteState.isCommuteLoading,
        commuteErrorMessage: state.commuteState.commuteErrorMessage,
        commuteExists: state.commuteState.doesCommuteExist,
        getCommute: () => store.dispatch(fetchCommute()),
        saveCommute: (Commute commute) =>
            store.dispatch(saveCommuteOp(commute)),
        deleteCommute: (Commute commute) =>
            store.dispatch(deleteCommuteOp(commute)),
        getLocation: () => store.dispatch(fetchLocation()));
  }
}

Commute reverseCommuteIfNecessary(Commute commute) {
  if (commute == null) {
    return null;
  }

  final now = TimeOfDay.fromDateTime(DateTime.now());

  // if needs to swap
  if (now.hour > commute.arrivalTime.hour + 1 &&
      now.hour < commute.departureTime.hour + 2) {
    // swap
    TimeOfDay temp = commute.departureTime;
    commute.departureTime = commute.arrivalTime;
    commute.arrivalTime = temp;

    Stop tempStop = commute.stop1;
    commute.stop1 = commute.stop2;
    commute.stop2 = tempStop;
  }
  return commute;
}
