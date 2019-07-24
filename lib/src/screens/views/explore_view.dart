// import 'package:flutter/material.dart';
// import 'package:mbta_companion/src/screens/states/explore_state.dart';
// import 'package:mbta_companion/src/widgets/stops_list_view.dart';

// class ExploreScreenView extends ExploreScreenState {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: <Widget>[
//           widget.topMessage == null
//               ? Container()
//               : Container(
//                   padding: EdgeInsets.all(10.0),
//                   child: Text(
//                     widget.topMessage,
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.caption,
//                   ),
//                 ),
//           Container(
//             padding: EdgeInsets.all(12.0),
//             child: TextField(
//               controller: searchBarController,
//               decoration: InputDecoration(
//                 hintText: "Search...",
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(25.0),
//                   ),
//                 ),
//               ),
//               onChanged: filterSearchResults,
//             ),
//           ),
//           Expanded(
//             child: filteredStops.length == 0
//                 ? noStopsFound()
//                 : StopsListView(filteredStops,
//                     onTap: widget.onTap, timeCircles: widget.timeCircles),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget noStopsFound() {
//     if (this.loading) {
//       return StopsLoadingIndicator();
//     }
//     return Container(
//       child: Center(
//         child: Text(
//           "No stops found\nTry searching something else",
//           textAlign: TextAlign.center,
//           style: Theme.of(context).textTheme.body2,
//         ),
//       ),
//     );
//   }
// }
