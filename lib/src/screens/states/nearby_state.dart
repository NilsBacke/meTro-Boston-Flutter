import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import '../views/nearby_view.dart';

class NearbyScreen extends StatefulWidget {
  @override
  NearbyScreenView createState() => NearbyScreenView();
}

abstract class NearbyScreenState extends State<NearbyScreen> {
  List<Stop> stops = List();
}
