import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'package:mbta_companion/src/services/permission_service.dart';
import '../views/explore_view.dart';

class ExploreScreen extends StatefulWidget {
  final Function(Stop) onTap;
  final String topMessage;
  final bool timeCircles;

  ExploreScreen({this.onTap, this.topMessage, this.timeCircles = true});

  @override
  ExploreScreenView createState() => ExploreScreenView();
}

abstract class ExploreScreenState extends State<ExploreScreen> {
  TextEditingController searchBarController = TextEditingController();
  List<Stop> stops = List();
  List<Stop> filteredStops = List();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getAllStops();
  }

  Future<void> getAllStops() async {
    var loc;
    LocationStatus locationStatus =
        await PermissionService.getLocationPermissions();
    if (locationStatus == LocationStatus.granted) {
      loc = await LocationService.currentLocation;
    } else {
      loc = null;
    }

    final stopList = await MBTAService.fetchAllStops(loc);
    this.stops = stopList;
    if (this.mounted) {
      setState(() {
        this.filteredStops = stopList;
        this.loading = false;
      });
    }
  }

  void filterSearchResults(String searchText) {
    this.filteredStops = this.stops;
    if (searchText.isNotEmpty && this.mounted) {
      setState(() {
        this.filteredStops = stops
            .where((stop) =>
                stop.name.toLowerCase().contains(searchText.toLowerCase()) ||
                stop.lineName
                    .toLowerCase()
                    .contains(searchText.toLowerCase()) ||
                stop.directionDescription
                    .toLowerCase()
                    .contains(searchText.toLowerCase()))
            .toList();
      });
    }
  }
}
