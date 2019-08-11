import 'package:location/location.dart';
import 'package:mbta_companion/src/models/stop.dart';

List<Stop> consolidate(List<Stop> fullList, LocationData locationData) {
  final sortedList = List.from(fullList);
  sortedList.sort((stop1, stop2) => stop1.name.compareTo(stop2.name));

  final List<Stop> result = [];
  for (int i = 0; i < sortedList.length; i++) {
    // not last element
    if (i != sortedList.length - 1) {
      result.add(sortedList[i]);
      // skip stop if same name
      if (sortedList[i].name == sortedList[i + 1].name) {
        i++;
      }
    }
  }

  return result;
}
