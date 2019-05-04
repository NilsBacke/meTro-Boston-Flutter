import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/views/add_saved_view.dart';
import 'package:mbta_companion/src/services/db_service.dart';

class AddSavedScreen extends StatefulWidget {
  @override
  AddSavedScreenView createState() => AddSavedScreenView();
}

abstract class AddSavedScreenState extends State<AddSavedScreen> {
  Future<void> onStopTapped(Stop stop) async {
    await DBService.db.saveStop(stop);
    Navigator.of(context).pop();
  }
}
