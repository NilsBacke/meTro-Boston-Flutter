import 'package:flutter/material.dart';
import 'package:mbta_companion/src/screens/states/add_saved_state.dart';
import 'package:mbta_companion/src/screens/states/saved_state.dart';
import 'package:mbta_companion/src/widgets/stops_list_view.dart';

class SavedScreenView extends SavedScreenState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddSavedScreen()))
              .then((val) {
            getAllSavedStops();
          });
        },
      ),
    );
  }

  Widget bodyWidget() {
    if (isLoading) {
      return StopsLoadingIndicator();
    } else if (savedStops.length == 0) {
      return emptyList();
    } else {
      return StopsListView(savedStops);
    }
  }

  Widget emptyList() {
    return Container(
      padding: EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.directions_transit,
                  size: 76.0,
                ),
                Container(
                  margin: EdgeInsets.only(left: 8.0, right: 8.0),
                  width: 1.5,
                  height: 60.0,
                  color: Colors.white30,
                ),
                Icon(
                  Icons.tram,
                  size: 76.0,
                ),
              ],
            ),
            Text(
              'No Saved Stops',
              style: Theme.of(context).textTheme.body1,
            ),
            Text(
              'Here you can see a list of your most frequently used stops \n\nAdd a stop to get started',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body2,
            ),
          ],
        ),
      ),
    );
  }
}
