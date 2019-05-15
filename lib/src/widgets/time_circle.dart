import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/prediction.dart';
import 'package:mbta_companion/src/services/mbta_stream_service.dart';
import 'package:mbta_companion/src/utils/timeofday_helper.dart';

class TimeCircleCombo extends StatefulWidget {
  final String stopId;

  TimeCircleCombo(this.stopId);

  @override
  _TimeCircleComboState createState() => _TimeCircleComboState();
}

class _TimeCircleComboState extends State<TimeCircleCombo> {
  List<Prediction> predictions = [null, null];
  StreamSubscription subscription;

  @override
  void initState() {
    getStream();
    super.initState();
  }

  Future<void> getStream() async {
    final stream =
        await MBTAStreamService.streamPredictionsForStopId(widget.stopId);
    subscription = stream.listen((PredictionEvent event) {
      print("event for stop: ${widget.stopId}: $event");

      if (!this.mounted) {
        return;
      }

      switch (event.event) {
        case "reset":
          setState(() {
            this.predictions = event.predictions;
          });
          break;
        case "update":
          _updatePredictions(event.predictions[0]);
          break;
        case "add":
          _addPrediction(event.predictions[0]);
      }
    });
  }

  void _updatePredictions(Prediction pred) {
    if (this.predictions[0].id == pred.id) {
      setState(() {
        this.predictions = [pred, this.predictions[1]];
      });
    } else if (this.predictions[1].id == pred.id) {
      setState(() {
        this.predictions = [this.predictions[0], pred];
      });
    }
  }

  void _addPrediction(Prediction pred) {
    setState(() {
      this.predictions[0] = this.predictions[1];
      this.predictions[1] = pred;
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (subscription != null) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95.0,
      child: rowWidget(this.predictions),
    );
  }

  Widget rowWidget(List<Prediction> predictions) {
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
  final Prediction prediction;
  final double height;
  final double width;

  TimeCircle(this.prediction, {this.height = 55.0, this.width = 55.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: StreamBuilder<int>(
          // in seconds
          stream: Stream.periodic(
            Duration(seconds: 1),
            compute,
          ),
          builder: (context, snapshot) {
            Color color = Colors.white;
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data < 60) {
                color = Colors.red;
              } else if (snapshot.data < 180) {
                color = Colors.yellow;
              }
            }

            String timeText = "---";
            double fontSize = this.width / 2.75;
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data <= 0) {
                timeText = "BOARD";
                fontSize = this.width / 4;
              } else {
                timeText = TimeOfDayHelper.formatSeconds(snapshot.data);
              }
            }

            double value = 1.0;
            if (snapshot.hasData && snapshot.data != null) {
              if (snapshot.data < 60) {
                value = (1 - snapshot.data / 60);
              }
            }
            return Stack(
              children: <Widget>[
                SizedBox(
                  height: height,
                  width: width,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 2.0,
                  ),
                ),
                Positioned.directional(
                  textDirection: TextDirection.ltr,
                  child: Center(
                    child: Text(
                      timeText,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  int compute(int countdown) {
    if (this.prediction == null) {
      return null;
    }
    return this.prediction.time.difference(DateTime.now()).inSeconds;
  }
}
