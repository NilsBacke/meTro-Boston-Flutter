import 'package:flutter/material.dart';
import 'time_circle.dart';

class VariablePartTile extends StatelessWidget {
  final String stopId;
  final String title;
  final String subtitle1;
  final String lineInitials;
  final Color lineColor;
  final List<String> otherInfo;
  final List<Widget> otherWidgets;
  final TextOverflow overflow;
  final bool timeCircles;

  VariablePartTile(this.stopId,
      {@required this.title,
      @required this.subtitle1,
      @required this.lineInitials,
      @required this.lineColor,
      this.otherInfo = const [],
      this.overflow = TextOverflow.ellipsis,
      this.otherWidgets = const [],
      this.timeCircles = true});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      Text(
        title,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.body1,
      ),
      Text(
        subtitle1,
        overflow: this.overflow,
        style: Theme.of(context).textTheme.body2,
      ),
    ];

    for (var i = 0; i < otherInfo.length; i++) {
      final String str = otherInfo[i];
      if (i == 0) {
        widgets.add(Text(
          str,
          overflow: this.overflow,
          style: Theme.of(context).textTheme.body2,
        ));
      } else if (i == 1) {
        widgets.add(Text(
          str,
          overflow: this.overflow,
          style: Theme.of(context).textTheme.body2,
        ));
      } else {
        widgets.add(Text(
          str,
          overflow: this.overflow,
          style: Theme.of(context).textTheme.caption,
        ));
      }
    }

    widgets.addAll(this.otherWidgets);

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
            this.timeCircles ? TimeCircleCombo(this.stopId) : Container(),
          ],
        ),
      ),
    );
  }
}
