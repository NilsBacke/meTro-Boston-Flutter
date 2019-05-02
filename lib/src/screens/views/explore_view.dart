import 'package:flutter/material.dart';
import 'package:mbta_companion/src/screens/states/explore_state.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/widgets/stop_card.dart';

class ExploreScreenView extends ExploreScreenState {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              controller: searchBarController,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
              ),
              onChanged: filterSearchResults,
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: getAllStops(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return loadingList();
                  }
                  return stopsListView();
                }),
          ),
        ],
      ),
    );
  }

  ListView stopsListView() {
    return ListView.builder(
      itemCount: stops.length,
      itemBuilder: (context, int index) {
        return StopCard(
          stop: stops[index],
          includeDistance: true,
          distanceFuture: LocationService.getDistanceFromStop(stops[index]),
        );
      },
    );
  }

  Center loadingList() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
