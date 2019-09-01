import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:location/location.dart';
import 'package:mbta_companion/src/analytics_widget.dart';
import 'package:mbta_companion/src/constants/amplitude_constants.dart';
import 'package:mbta_companion/src/constants/string_constants.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/ExploreScreen/utils/filter_search_results.dart';
import 'package:mbta_companion/src/services/permission_service.dart';
import 'package:mbta_companion/src/state/actions/allStopsActions.dart';
import 'package:mbta_companion/src/state/operations/allStopsOperations.dart';
import 'package:mbta_companion/src/state/operations/locationOperations.dart';
import 'package:mbta_companion/src/state/state.dart';
import 'package:mbta_companion/src/utils/show_error_dialog.dart';
import 'package:mbta_companion/src/utils/stops_list_helpers.dart';
import 'package:mbta_companion/src/widgets/error_text_widget.dart';
import 'package:mbta_companion/src/widgets/stops_list_view.dart';
import 'package:redux/redux.dart';

enum FilterType {
  All,
  Subway,
  Bus,
}

class ExploreScreen extends StatefulWidget {
  final Function(Stop) onTap;
  final String topMessage;
  final bool timeCircles;
  final bool consolidated;
  final bool includeOtherInfo;

  ExploreScreen(
      {this.onTap,
      this.topMessage,
      this.timeCircles = true,
      this.consolidated = false,
      this.includeOtherInfo = true});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  TextEditingController searchBarController = TextEditingController();
  List<Stop> filteredStops;
  FilterType currentFilter = FilterType.Subway;

  void onInit(_ExploreViewModel viewModel) {
    AnalyticsWidget.of(context)
        .analytics
        .logEvent(name: exploreScreenLoadAmplitude);

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
  }

  Widget getBodyWidget(_ExploreViewModel viewModel) {
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
      Future.delayed(Duration.zero,
          () => showErrorDialog(context, viewModel.allStopsErrorMessage));
      return errorTextWidget(context, text: viewModel.allStopsErrorMessage);
    }

    // loading
    if (filteredStops == null ||
        viewModel.isAllStopsLoading ||
        viewModel.isLocationLoading) {
      return StopsLoadingIndicator();
    }

    if (filteredStops != null &&
        filteredStops.length == 0 &&
        viewModel.allStops.length != 0) {
      return errorTextWidget(context,
          text:
              "No stops found.\nTry searching something else."); // TODO: put in constants
    }

    return WillPopScope(
      onWillPop: () async {
        viewModel.clearError();
        return true;
      },
      child: StopsListView(filteredStops,
          onTap: widget.onTap,
          timeCircles: widget.timeCircles,
          includeOtherInfo: widget.includeOtherInfo),
    );
  }

  void filter(_ExploreViewModel viewModel, String searchText) {
    this.filteredStops = viewModel.allStops;

    if (this.currentFilter == FilterType.Subway) {
      this.filteredStops = this.filteredStops.where((stop) =>
          stop.routeType == RouteType.tram ||
          stop.routeType == RouteType.subway);
    } else if (this.currentFilter == FilterType.Bus) {
      this.filteredStops =
          this.filteredStops.where((stop) => stop.routeType == RouteType.bus);
    }

    this.filteredStops =
        filterSearchResults(searchText, viewModel.allStops, this.mounted);
    this.setState(() {});
  }

  Widget searchBar(_ExploreViewModel viewModel) {
    return Container(
      margin: EdgeInsets.all(12.0),
      height: 70,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Center(
          child: ListTile(
            dense: true,
            leading: Icon(Icons.search),
            title: Container(
              child: TextField(
                controller: searchBarController,
                onChanged: (searchText) {
                  filter(viewModel, searchText);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Park St...",
                ),
                textCapitalization: TextCapitalization.sentences,
                cursorColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget filterSelector() {
    return Container(
      margin: EdgeInsets.only(left: 1.0, right: 1.0, bottom: 16.0, top: 2.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CupertinoSegmentedControl(
          unselectedColor: Theme.of(context).backgroundColor,
          selectedColor: Colors.white,
          borderColor: Colors.grey,
          children: <FilterType, Widget>{
            FilterType.All: Text(
              'All',
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'Hind',
                color: this.currentFilter == FilterType.All
                    ? Colors.black87
                    : Colors.white,
              ),
            ),
            FilterType.Subway: Text(
              'Subway',
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'Hind',
                color: this.currentFilter == FilterType.Subway
                    ? Colors.black87
                    : Colors.white,
              ),
            ),
            FilterType.Bus: Text(
              'Bus',
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'Hind',
                color: this.currentFilter == FilterType.Bus
                    ? Colors.black87
                    : Colors.white,
              ),
            ),
          },
          onValueChanged: (FilterType newFilterType) {
            setState(() {
              this.currentFilter = newFilterType;
            });
          },
          groupValue: this.currentFilter,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StoreConnector<AppState, _ExploreViewModel>(
        onInit: (store) =>
            this.onInit(_ExploreViewModel.create(store, widget.consolidated)),
        converter: (store) =>
            _ExploreViewModel.create(store, widget.consolidated),
        builder: (context, _ExploreViewModel viewModel) {
          if (viewModel.allStops != null &&
              viewModel.allStops.length != 0 &&
              this.filteredStops == null) {
            this.filteredStops = viewModel.allStops;
          }

          final bodyWidget = getBodyWidget(viewModel);

          return Column(
            children: <Widget>[
              widget.topMessage == null
                  ? Container()
                  : Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        widget.topMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
              searchBar(viewModel),
              filterSelector(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final viewModel = _ExploreViewModel.create(
                        StoreProvider.of(context), widget.consolidated);
                    viewModel.getLocation();
                    if (viewModel.location != null) {
                      viewModel.getAllStops(viewModel.location);
                    }
                    await Future.delayed(Duration(seconds: 1));
                  },
                  child: bodyWidget,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ExploreViewModel {
  final LocationData location;
  final bool isLocationLoading;
  final LocationStatus locationErrorStatus;
  final List<Stop> allStops;
  final bool isAllStopsLoading;
  final String allStopsErrorMessage;

  final Function() getLocation;
  final Function(LocationData) getAllStops;
  final Function() clearError;

  _ExploreViewModel(
      {this.location,
      this.isLocationLoading,
      this.locationErrorStatus,
      this.allStops,
      this.isAllStopsLoading,
      this.allStopsErrorMessage,
      this.getLocation,
      this.getAllStops,
      this.clearError});

  factory _ExploreViewModel.create(Store<AppState> store, bool consolidated) {
    final state = store.state;
    return _ExploreViewModel(
        location: state.locationState.locationData,
        isLocationLoading: state.locationState.isLocationLoading,
        locationErrorStatus: state.locationState.locationErrorStatus,
        allStops: consolidated
            ? consolidate(
                state.allStopsState.allStops, state.locationState.locationData)
            : state.allStopsState.allStops,
        isAllStopsLoading: state.allStopsState.isAllStopsLoading,
        allStopsErrorMessage: state.allStopsState.allStopsErrorMessage,
        getLocation: () => store.dispatch(fetchLocation()),
        getAllStops: (LocationData locationData) =>
            store.dispatch(fetchAllStops(locationData)),
        clearError: () => store.dispatch(AllStopsClearError()));
  }
}
