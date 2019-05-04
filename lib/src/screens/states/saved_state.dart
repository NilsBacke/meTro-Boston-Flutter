import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/views/saved_view.dart';
import 'package:mbta_companion/src/services/db_service.dart';

class SavedScreen extends StatefulWidget {
  @override
  SavedScreenView createState() => SavedScreenView();
}

abstract class SavedScreenState extends State<SavedScreen> {
  bool isLoading = true;
  List<Stop> savedStops = List();

  @override
  void initState() {
    super.initState();
    isLoading = false;
    getAllSavedStops();
  }

  Future<void> getAllSavedStops() async {
    final savedStops = await DBService.db.getAllSavedStops();
    setState(() {
      this.savedStops = savedStops;
    });
  }
}
