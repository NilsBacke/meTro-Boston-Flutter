import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import '../views/explore_view.dart';

class ExploreScreen extends StatefulWidget {
  @override
  ExploreScreenView createState() => ExploreScreenView();
}

abstract class ExploreScreenState extends State<ExploreScreen> {
  TextEditingController searchBarController = TextEditingController();
  List<Stop> stops = List();

  Future<List<Stop>> getAllStops() async {
    final loc = await LocationService.currentLocation;
    final stopList = await MBTAService.getAllStops(loc);
    this.stops = stopList;

    return stopList;
  }

  void filterSearchResults(String searchText) {
    if (searchText.isNotEmpty) {
      setState(() {
        this.stops = stops
            .where((stop) =>
                stop.name.contains(searchText) ||
                stop.lineName.contains(searchText) ||
                stop.directionDescription.contains(searchText))
            .toList();
      });
    }
  }
}
