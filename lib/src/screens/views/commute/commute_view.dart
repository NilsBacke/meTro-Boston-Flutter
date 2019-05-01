import 'package:flutter/material.dart';
import '../../states/commute/commute_state.dart';

class CommuteView extends CommuteScreenState {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Stop $data"),
      ),
    );
  }
}
