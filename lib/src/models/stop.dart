import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Stop {
  String id;
  String name;
  double latitude;
  double longitude;
  String directionDestination;
  String directionName;
  String lineName;
  String textColorHex;
  String lineColorHex;
  String lineInitials;
  String directionDescription;

  Color get lineColor {
    return Color(int.parse(lineColorHex));
  }

  Color get textColor {
    return Color(int.parse(textColorHex));
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
  static const directionDestinationKey = "directionDestination";
  static const directionNameKey = "directionName";
  static const lineNameKey = "lineName";
  static const textColorHexKey = "textColorHex";
  static const lineColorHexKey = "lineColorHex";
  static const lineInitialsKey = "lineInitials";
  static const directionDescriptionKey = "directionDescription";

  Stop(
      this.id,
      this.name,
      this.latitude,
      this.longitude,
      this.directionDestination,
      this.directionName,
      this.lineName,
      this.textColorHex,
      this.lineColorHex,
      this.lineInitials,
      this.directionDescription);

  Stop.from(Map<String, dynamic> parsedJson) {
    this.id = parsedJson[idKey].toString();
    this.name = parsedJson[nameKey];
    this.latitude = parsedJson[latitudeKey];
    this.longitude = parsedJson[longitudeKey];
    this.directionDestination = parsedJson[directionDestinationKey];
    this.directionName = parsedJson[directionNameKey];
    this.lineName = parsedJson[lineNameKey];
    this.textColorHex = parsedJson[textColorHexKey];
    this.lineColorHex = parsedJson[lineColorHexKey];
    this.lineInitials = parsedJson[lineInitialsKey];
    this.directionDescription = parsedJson[directionDescriptionKey];
  }

  Map<String, dynamic> toJson() => {
        idKey: id,
        nameKey: name,
        longitudeKey: longitude,
        latitudeKey: latitude,
        directionDestinationKey: directionDestination,
        directionNameKey: directionName,
        lineNameKey: lineName,
        textColorHexKey: textColorHex,
        lineColorHexKey: lineColorHex,
        lineInitialsKey: lineInitials,
        directionDescriptionKey: directionDescription,
      };
}
