class Vehicle {
  String id;
  double bearing;
  double latitude;
  double longitude;
  double speed;
  String updatedAt;
  String lineName;
  String directionDestination;

  static const idKey = "id";
  static const bearingKey = "bearing";
  static const latitudeKey = "latitude";
  static const longitudeKey = "longitude";
  static const speedKey = "speed";
  static const lineNameKey = "lineName";
  static const updatedAtKey = "updatedAt";
  static const directionDestinationKey = "directionDestination";

  Vehicle(this.id, this.bearing, this.latitude, this.longitude, this.speed,
      this.updatedAt, this.lineName, this.directionDestination);

  Vehicle.fromJson(Map<String, dynamic> parsedJson) {
    this.id = parsedJson[idKey];
    this.bearing = parsedJson[bearingKey];
    this.latitude = parsedJson[latitudeKey];
    this.longitude = parsedJson[longitudeKey];
    this.directionDestination = parsedJson[directionDestinationKey];
    this.speed = parsedJson[speedKey];
    this.lineName = parsedJson[lineNameKey];
    this.updatedAt = parsedJson[updatedAtKey];
  }
}
