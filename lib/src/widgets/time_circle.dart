import 'package:flutter/material.dart';

class TimeCircleCombo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95.0,
      child: Row(
        children: <Widget>[
          TimeCircle(),
          TimeCircle(
            height: 40.0,
            width: 40.0,
          ),
        ],
      ),
    );
  }
}

class TimeCircle extends StatelessWidget {
  final double height;
  final double width;

  TimeCircle({this.height = 55.0, this.width = 55.0});

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
                '15m',
                style: TextStyle(fontSize: this.width / 2.75),
              ),
            ),
          )
        ],
      ),
    );
  }
}
