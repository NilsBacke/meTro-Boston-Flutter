import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/states/explore_state.dart';

class SetStopView extends StatelessWidget {
  final bool homeStop;
  final Function(Stop) onTap;

  SetStopView(this.homeStop, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set ${homeStop ? 'Home' : 'Work'} Stop'),
      ),
      body: ExploreScreen(
        onTap: onTap,
        topMessage: homeStop
            ? 'Please select the line and direction that you use when getting on the train from home.'
            : 'Please select the line and direction that you use when getting on the train from work.',
        timeCircles: false,
      ),
    );
  }
}