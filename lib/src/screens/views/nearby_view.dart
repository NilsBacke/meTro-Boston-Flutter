import 'package:flutter/material.dart';
import '../states/nearby_state.dart';
import '../../widgets/stop_details_tile.dart';

class NearbyScreenView extends NearbyScreenState {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return SafeArea(
    //   child: ListView.builder(
    //     itemCount: stops.length,
    //     itemBuilder: (context, int index) {
    //       final stop = stops[index];
    //       return ThreePartTile(
    //         title: stop.name,
    //         subtitle1: stop.lineName,
    //         subtitle2: stop.directionDescription,
    //         lineInitials: stop.lineInitials,
    //         lineColor: stop.lineColor,
    //       );
    //     },
    //   ),
    // );
  }
}
