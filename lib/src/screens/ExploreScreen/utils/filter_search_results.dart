import 'package:mbta_companion/src/models/stop.dart';

List<Stop> filterSearchResults(
    String searchText, List<Stop> stops, bool mounted) {
  List<Stop> filteredStops = stops;
  if (searchText.isNotEmpty && mounted) {
    filteredStops = stops
        .where((stop) =>
            stop.name.toLowerCase().contains(searchText.toLowerCase()) ||
            stop.lineName.toLowerCase().contains(searchText.toLowerCase()) ||
            stop.directionDescription
                .toLowerCase()
                .contains(searchText.toLowerCase()))
        .toList();

    filteredStops.sort((stop1, stop2) {
      if (stop1.name.toLowerCase().contains(searchText.toLowerCase())) {
        // at top
        return -1;
      }
      return 1;
    });
  }

  return filteredStops;
}
