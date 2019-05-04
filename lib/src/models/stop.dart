import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/mbta_colors.dart';

class Stop {
  String id;
  String name;
  double latitude;
  double longitude;
  String directionDestination;
  String directionName;
  String lineName;

  String get directionDescription =>
      this.directionName + "bound towards " + this.directionDestination;
  String get lineInitials => this.lineName == "Mattapan"
      ? "M"
      : this.lineName[0].toUpperCase() +
          this.lineName[this.lineName.indexOf(" ") + 1].toUpperCase();
  Color get lineColor {
    switch (this.lineName) {
      case "Orange Line":
        return MBTAColors.orange;
      case "Green Line":
        return MBTAColors.green;
      case "Blue Line":
        return MBTAColors.blue;
      case "Red Line":
      case "Mattapan":
      case "Mattapan Trolley":
        return MBTAColors.red;
      default:
        throw Exception('Cannot find a color for line: ' + this.lineName);
    }
  }

  Color get textColor {
    switch (this.lineName) {
      case "Orange Line":
        return Colors.orange;
      case "Green Line":
        return Colors.green;
      case "Blue Line":
        return Colors.blue;
      case "Red Line":
      case "Mattapan":
      case "Mattapan Trolley":
        return Colors.red;
      default:
        throw Exception('Cannot find a color for line: ' + this.lineName);
    }
  }

  BitmapDescriptor get marker {
    switch (this.lineName) {
      case "Orange Line":
        return BitmapDescriptor.defaultMarkerWithHue(35.0);
      case "Green Line":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case "Blue Line":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case "Red Line":
      case "Mattapan":
      case "Mattapan Trolley":
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      default:
        throw Exception('Cannot find a color for line: ' + this.lineName);
    }
  }

  static const idKey = "id";
  static const nameKey = "name";
  static const latitudeKey = "latitude";
  static const longitudeKey = "longitude";
  static const directionKey = "platform_name";
  static const attributesKey = "attributes";
  static const lineNameKey = "description";
  static const directionNameKey = "direction_name";

  static const List<String> northList = ["Alewife", "Oak Grove"];
  static const List<String> southList = [
    "Ashmont/Braintree",
    "Ashmont",
    "Braintree",
    "Forest Hills",
    "Mattapan"
  ];
  static const List<String> westList = [
    "Bowdoin",
    "Boston College",
    "Cleveland Circle",
    "Riverside",
    "Heath Street",
    "Cleveland Circle/Riverside"
  ];
  static const List<String> eastList = [
    "Wonderland",
    "Park Street",
    "North Station",
    "Government Center",
    "Lechmere"
  ];

  Stop(this.id, this.name, this.latitude, this.longitude,
      this.directionDestination, this.directionName, this.lineName);

  Stop.fromJson(Map<String, dynamic> parsedJson) {
    final attributes = parsedJson[attributesKey];
    this.id = parsedJson[idKey];
    this.name = attributes[nameKey];
    this.latitude = attributes[latitudeKey];
    this.longitude = attributes[longitudeKey];
    this.directionDestination = attributes[directionKey];
    this.directionName =
        _convertDirectionToName(this.directionDestination, this.id);
    final String desc = attributes[lineNameKey];

    // formulate line name
    try {
      this.lineName =
          desc.substring(desc.indexOf("- ") + 2, desc.lastIndexOf(" -"));
    } on Error catch (e) {
      try {
        this.lineName = desc.substring(desc.indexOf("- ") + 2);
      } on Error catch (e) {
        throw Exception('Could not formulate line name from: $desc. Error: $e');
      }
    }
  }

  Stop.fromDb(Map<String, dynamic> parsedJson) {
    this.id = parsedJson[idKey].toString();
    this.name = parsedJson[nameKey];
    this.latitude = double.parse(parsedJson[latitudeKey]);
    this.longitude = double.parse(parsedJson[longitudeKey]);
    this.directionDestination = parsedJson[directionKey];
    this.directionName = parsedJson[directionNameKey];
    this.lineName = parsedJson[lineNameKey];
  }

  Map<String, dynamic> toJson() => {
        idKey: id,
        nameKey: name,
        longitudeKey: longitude.toString(),
        latitudeKey: latitude.toString(),
        directionKey: directionDestination,
        directionNameKey: directionName,
        lineNameKey: lineName,
      };

  String _convertDirectionToName(String direction, String id) {
    if (direction == "Park Street & North") {
      return "East";
    }

    if (northList.contains(direction) ||
        direction.toLowerCase().contains("north") ||
        direction.toLowerCase().contains(
            northList.fold("", (t1, t2) => t1.toString() + t2.toString()))) {
      return "North";
    } else if (southList.contains(direction) ||
        direction.toLowerCase().contains("south") ||
        direction.toLowerCase().contains(
            southList.fold("", (t1, t2) => t1.toString() + t2.toString()))) {
      return "South";
    } else if (eastList.contains(direction) ||
        direction.toLowerCase().contains("east") ||
        direction.toLowerCase().contains(
            eastList.fold("", (t1, t2) => t1.toString() + t2.toString()))) {
      return "East";
    } else if (westList.contains(direction) ||
        direction.toLowerCase().contains("west") ||
        direction.toLowerCase().contains(
            westList.fold("", (t1, t2) => t1.toString() + t2.toString()))) {
      return "West";
    } else {
      // TODO will need to do something with these weird stops
      return "";
    }
  }
}
