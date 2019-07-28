// import 'package:flutter/material.dart';
// import 'package:mbta_companion/src/models/commute.dart';
// import 'package:mbta_companion/src/models/stop.dart';
// import 'package:mbta_companion/src/screens/views/create_commute_view.dart';
// import 'package:mbta_companion/src/services/db_service.dart';
// import 'package:mbta_companion/src/utils/timeofday_helper.dart';
// import 'package:mbta_companion/src/widgets/set_stop_view.dart';

// class CreateCommuteScreen extends StatefulWidget {
//   Commute commute;
//   CreateCommuteScreen({this.commute});

//   @override
//   CreateCommuteScreenView createState() => CreateCommuteScreenView();
// }

// abstract class CreateCommuteScreenState extends State<CreateCommuteScreen> {
//   String appBarText;
//   Stop stop1, stop2;
//   TimeOfDay arrivalTime, departureTime;

//   @override
//   initState() {
//     if (widget.commute != null) {
//       if (isCommuteSwapped()) {
//         this.stop1 = widget.commute.stop2;
//         this.stop2 = widget.commute.stop1;
//         this.arrivalTime = widget.commute.departureTime;
//         this.departureTime = widget.commute.arrivalTime;
//       } else {
//         this.stop1 = widget.commute.stop1;
//         this.stop2 = widget.commute.stop2;
//         this.arrivalTime = widget.commute.arrivalTime;
//         this.departureTime = widget.commute.departureTime;
//       }
//       this.appBarText = "Update Commute";
//     } else {
//       this.arrivalTime = TimeOfDay(hour: 9, minute: 0);
//       this.departureTime = TimeOfDay(hour: 17, minute: 0);
//       this.appBarText = "Create Commute";
//     }
//     super.initState();
//   }

//   bool isCommuteSwapped() {
//     return !(widget.commute.stop1.id == widget.commute.homeStopId);
//   }

//   String get arrivalTimeString {
//     return TimeOfDayHelper.convertToString(arrivalTime);
//   }

//   String get departureTimeString {
//     return TimeOfDayHelper.convertToString(departureTime);
//   }

//   void pickTime(bool arrival) {
//     showTimePicker(
//       context: context,
//       initialTime: arrival
//           ? TimeOfDay(hour: 9, minute: 0)
//           : TimeOfDay(hour: 17, minute: 0),
//     ).then((time) {
//       if (time != null) {
//         setState(() {
//           arrival ? arrivalTime = time : departureTime = time;
//         });
//       }
//     });
//   }

//   Future<void> chooseStop(bool homeStop, {Stop currentStop}) async {
//     Stop stop = await Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => SetStopView(
//               homeStop,
//               (stop) {
//                 Navigator.of(context).pop(stop);
//               },
//             ),
//       ),
//     );

//     if (!this.mounted) {
//       return;
//     }

//     // nothing was tapped
//     if (stop == null) {
//       stop = currentStop;
//     }

//     if (homeStop) {
//       setState(() {
//         this.stop1 = stop;
//       });
//     } else {
//       setState(() {
//         this.stop2 = stop;
//       });
//     }
//   }

//   Future<void> createCommute() async {
//     if (stop1 == null || stop2 == null) {
//       showUnableToCreateDialog();
//       return;
//     }

//     final commute = Commute(stop1, stop2, arrivalTime, departureTime);
//     if (widget.commute == null) {
//       // create commute
//       await DBService.db.saveCommute(commute);
//     } else {
//       // update commute
//       await DBService.db.updateCommute(commute);
//     }

//     Navigator.of(context).pop();
//   }

//   void showUnableToCreateDialog() {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text(
//               'Unable to create commute',
//               style: Theme.of(context).textTheme.body1,
//             ),
//             content: Text(
//               'Make sure you have both a home and work stop chosen',
//               style: Theme.of(context).textTheme.body2,
//             ),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('Close'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               )
//             ],
//           );
//         });
//   }
// }
