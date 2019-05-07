import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/commute.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/screens/views/create_commute_view.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mbta_companion/src/widgets/set_stop_view.dart';

import 'explore_state.dart';

class CreateCommuteScreen extends StatefulWidget {
  @override
  CreateCommuteScreenView createState() => CreateCommuteScreenView();
}

abstract class CreateCommuteScreenState extends State<CreateCommuteScreen> {
  Commute commute;
  Stop stop1, stop2;
  TimeOfDay arrivalTime, departureTime;

  String get arrivalTimeString {
    if (arrivalTime == null) {
      return "9:00 AM";
    }
    return _formatTime(arrivalTime);
  }

  String get departureTimeString {
    if (departureTime == null) {
      return "5:00 PM";
    }
    return _formatTime(departureTime);
  }

  String _formatTime(TimeOfDay time) {
    String minute = time.minute.toString();
    if (time.minute < 10) {
      minute = "0${time.minute}";
    }
    if (time.hour > 12) {
      return '${time.hour - 12}:$minute PM';
    }
    return '${time.hour}:$minute AM';
  }

  void pickTime(bool arrival) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((time) {
      setState(() {
        arrival ? arrivalTime = time : departureTime = time;
      });
    });
  }

  Future<void> chooseStop(bool homeStop) async {
    final stop = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SetStopView(
              homeStop,
              (stop) {
                Navigator.of(context).pop(stop);
              },
            ),
      ),
    );

    if (!this.mounted) {
      return;
    }

    if (homeStop) {
      setState(() {
        this.stop1 = stop;
      });
    } else {
      setState(() {
        this.stop2 = stop;
      });
    }
  }
}
