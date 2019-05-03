import 'package:flutter/material.dart';
import 'package:mbta_companion/src/models/stop.dart';
import 'package:mbta_companion/src/services/mbta_stream_service.dart';

class TimeCircleCombo extends StatelessWidget {
  final String stopId;

  TimeCircleCombo(this.stopId);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95.0,
      child: FutureBuilder(
          future: MBTAStreamService.getPredictionsForStopId(stopId),
          builder: (context, snapshot) {
            String timeText1 = '---';
            String timeText2 = '---';
            if (snapshot.hasData) {
              timeText1 = snapshot.data[0];
              timeText2 = snapshot.data[1];
            }
            return Row(
              children: <Widget>[
                TimeCircle(timeText1),
                TimeCircle(
                  timeText2,
                  height: 40.0,
                  width: 40.0,
                ),
              ],
            );
          }),
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
