import 'package:flutter/material.dart';
import 'package:mbta_companion/src/utils/mbta_colors.dart';
import 'time_circle.dart';

class TwoPartTile extends StatelessWidget {
  final String title;
  final String subtitle1;
  final List<Widget> extraWidgets;

  TwoPartTile({this.title, this.subtitle1, this.extraWidgets = const []});

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
                  "OL",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: MBTAColors.orange,
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

  ThreePartTile({this.title, this.subtitle1, this.subtitle2});

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
    );
  }
}
