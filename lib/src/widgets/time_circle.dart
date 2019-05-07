import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/mbta_stream_service.dart';

class TimeCircleCombo extends StatefulWidget {
  final String stopId;

  TimeCircleCombo(this.stopId);

  @override
  _TimeCircleComboState createState() => _TimeCircleComboState();
}

class _TimeCircleComboState extends State<TimeCircleCombo> {
  List<String> predictions = List.from(["---", "---"]);

  @override
  void initState() {
    super.initState();
    getPredictions();
  }

  Future<void> getPredictions() async {
    final preds =
        await MBTAStreamService.getPredictionsForStopId(widget.stopId);
    if (this.mounted) {
      setState(() {
        this.predictions = preds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95.0,
      child: Row(
        children: <Widget>[
          TimeCircle(predictions[0]),
          TimeCircle(
            predictions[1],
            height: 40.0,
            width: 40.0,
          ),
        ],
      ),
    );
  }
}

class TimeCircle extends StatelessWidget {
  final String text;
  final double height;
  final double width;

  TimeCircle(this.text, {this.height = 55.0, this.width = 55.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: height,
            width: width,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 2.0,
            ),
          ),
          Positioned.directional(
            textDirection: TextDirection.ltr,
            child: Center(
              child: Text(
                this.text,
                style: TextStyle(fontSize: this.width / 2.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
