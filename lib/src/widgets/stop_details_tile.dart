import 'package:flutter/material.dart';
import 'package:mbta_companion/src/utils/mbta_colors.dart';
import 'time_circle.dart';

class TwoPartTile extends StatelessWidget {
  final String title;
  final String subtitle1;
  final List<Widget> extraWidgets;
  final String lineInitials;
  final Color lineColor;

  TwoPartTile(
      {@required this.title,
      @required this.subtitle1,
      this.extraWidgets = const [],
      @required this.lineInitials,
      @required this.lineColor});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Text(
        title,
        overflow: TextOverflow.clip,
        style: Theme.of(context).textTheme.body1,
      ),
      Text(
        subtitle1,
        overflow: TextOverflow.clip,
        style: Theme.of(context).textTheme.body2,
      ),
    ];
    widgets.addAll(this.extraWidgets);

    return Container(
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                child: Text(
                  lineInitials,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: lineColor,
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widgets,
                ),
              ),
            ),
            TimeCircleCombo(),
          ],
        ),
      ),
    );
  }
}

class ThreePartTile extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String lineInitials;
  final Color lineColor;

  ThreePartTile(
      {@required this.title,
      @required this.subtitle1,
      @required this.subtitle2,
      @required this.lineInitials,
      @required this.lineColor});

  @override
  Widget build(BuildContext context) {
    return TwoPartTile(
      title: this.title,
      subtitle1: this.subtitle1,
      extraWidgets: <Widget>[
        Text(
          subtitle2,
          overflow: TextOverflow.clip,
          style: Theme.of(context).textTheme.body2,
        ),
      ],
      lineInitials: lineInitials,
      lineColor: lineColor,
    );
  }
}
