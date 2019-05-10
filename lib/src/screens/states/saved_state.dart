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
    getAllSavedStops();
  }

  Future<void> getAllSavedStops() async {
    final savedStops = await DBService.db.getAllSavedStops();
    if (this.mounted) {
      setState(() {
        this.isLoading = false;
        this.savedStops = savedStops;
      });
    }
  }

  Future<void> removeStop(Stop stop) async {
    setState(() {
      this.savedStops.remove(stop);
    });
    final res = await DBService.db.removeSavedStop(int.parse(stop.id));
    if (res == 0) {
      throw 'Stop not removed from db, stop does not exist';
    }
  }
}
