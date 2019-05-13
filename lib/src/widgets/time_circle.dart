import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:eventsource/eventsource.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/mbta_stream_service.dart';
import 'package:mbta_companion/src/utils/timeofday_helper.dart';

class TimeCircleCombo extends StatefulWidget {
  final String stopId;

  TimeCircleCombo(this.stopId);

  @override
  _TimeCircleComboState createState() => _TimeCircleComboState();
}

class _TimeCircleComboState extends State<TimeCircleCombo> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  getPredictionStream() {
    return this._memoizer.runOnce(() async {
      return MBTAStreamService.streamPredictionsForStopId(widget.stopId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95.0,
      child: FutureBuilder(
        future: getPredictionStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return rowWidget([null, null]);
          }
          return StreamBuilder<List<DateTime>>(
            stream: snapshot.data,
            initialData: [null, null],
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return rowWidget([null, null]);
              }
              if (snapshot.hasError) {
                throw 'Error: ' + snapshot.error;
              }
              return rowWidget(snapshot.data);
            },
          );
        },
      ),
    );
  }

  Widget rowWidget(List<DateTime> predictions) {
    assert(predictions != null);
    assert(predictions.length == 2);

    return Row(
      children: <Widget>[
        TimeCircle(predictions[0]),
        TimeCircle(
          predictions[1],
          height: 40.0,
          width: 40.0,
        ),
      ],
    );
  }
}

class TimeCircle extends StatelessWidget {
  final DateTime time;
  final double height;
  final double width;

  TimeCircle(this.time, {this.height = 55.0, this.width = 55.0});

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
                this.time != null
                    ? TimeOfDayHelper.getDifferenceFormatted(
                        this.time, DateTime.now())
                    : "---",
                style: TextStyle(fontSize: this.width / 2.75),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
