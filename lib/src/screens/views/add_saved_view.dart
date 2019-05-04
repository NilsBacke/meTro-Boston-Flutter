import 'package:flutter/material.dart';
import 'package:mbta_companion/src/screens/states/add_saved_state.dart';
import 'package:mbta_companion/src/screens/states/explore_state.dart';

class AddSavedScreenView extends AddSavedScreenState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Stop'),
      ),
      body: ExploreScreen(onTap: onStopTapped),
    );
  }
}
