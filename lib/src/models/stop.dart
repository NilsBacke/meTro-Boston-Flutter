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
  int routeType;

  Color get lineColor {
    try {
      return Color(int.parse(lineColorHex));
    } on Exception catch (e) {
      print(id);
      print(lineColorHex);
    }
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
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
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
  static const routeTypeKey = "routeType";

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
      this.directionDescription,
      this.routeType);

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
    this.routeType = parsedJson[routeTypeKey];
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
        routeTypeKey: routeType
      };
}
