import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/ExploreScreen/explore_screen.dart';

class AddSavedScreen extends StatelessWidget {
  final Function(Stop) addStop;

  AddSavedScreen(this.addStop);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add New Stop'),
      ),
      body: ExploreScreen(onTap: addStop),
    );
  }
}
