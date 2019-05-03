import 'package:flutter/material.dart';
import 'package:mbta_companion/src/screens/states/explore_state.dart';
import 'package:mbta_companion/src/services/location_service.dart';
import 'package:mbta_companion/src/widgets/stop_card.dart';
import 'package:mbta_companion/src/widgets/stops_list_view.dart';

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
            child: filteredStops.length == 0
                ? StopsLoadingIndicator()
                : StopsListView(filteredStops),
          ),
        ],
      ),
    );
  }
}
