import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import '../views/explore_view.dart';

class ExploreScreen extends StatefulWidget {
  final Function(Stop) onTap;

  ExploreScreen({this.onTap});

  @override
  ExploreScreenView createState() => ExploreScreenView();
}

abstract class ExploreScreenState extends State<ExploreScreen> {
  TextEditingController searchBarController = TextEditingController();
  List<Stop> stops = List();
  List<Stop> filteredStops = List();

  @override
  void initState() {
    super.initState();
    getAllStops();
  }

  Future<void> getAllStops() async {
    final loc = await LocationService.currentLocation;
    final stopList = await MBTAService.fetchAllStops(loc);
    this.stops = stopList;
    setState(() {
      this.filteredStops = stopList;
    });
  }

  void filterSearchResults(String searchText) {
    this.filteredStops = this.stops;
    if (searchText.isNotEmpty) {
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
