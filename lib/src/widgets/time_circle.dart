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
    subscription = stream.listen((List<Prediction> preds) {
      print("preds for stop: ${widget.stopId}: $preds");
      if (this.predictions == null) {
        if (this.mounted) {
          setState(() {
            this.predictions = preds;
          });
        }
      } else {
        List<Prediction> tempPreds = this.predictions;

        for (int i = 0; i < this.predictions.length; i++) {
          if (this.predictions[i] == null ||
              (preds[i] != null && this.predictions[i].id == preds[i].id)) {
            tempPreds[i] = preds[i];
          } else if (preds[i] != null &&
              TimeOfDayHelper.getDifferenceFormatted(
                      this.predictions[i].time, DateTime.now()) ==
                  "BOARD") {
            assert(i == 0);
            tempPreds[i] = tempPreds[i + 1];
            tempPreds[i + 1] = preds[i];
          }
        }
        if (this.mounted) {
          setState(() {
            this.predictions = tempPreds;
          });
        }
      }
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
      child: StreamBuilder<String>(
          stream: Stream.periodic(
            Duration(seconds: 1),
            compute,
          ),
          builder: (context, snapshot) {
            return Stack(
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
                      snapshot.data ?? "---",
                      style: TextStyle(fontSize: this.width / 2.75),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  String compute(int countdown) {
    if (this.prediction == null) {
      return "---";
    }
    return TimeOfDayHelper.getDifferenceFormatted(
        this.prediction.time, DateTime.now());
  }
}
