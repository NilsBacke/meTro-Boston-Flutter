import 'stop.dart';

class Commute {
  int id;
  Stop stop1, stop2;

  Commute(this.stop1, this.stop2) {
    this.id = 1;
  }

  Commute.fromJson(Map<String, dynamic> parsedJson) {
    this.id = 1;
    this.stop1 = Stop(
        parsedJson['id_one'],
        parsedJson['name_one'],
        parsedJson['latitude_one'],
        parsedJson['longitude_one'],
        parsedJson['platform_name_one'],
        parsedJson['direction_name_one']);
    this.stop2 = Stop(
        parsedJson['id_two'],
        parsedJson['name_two'],
        parsedJson['latitude_two'],
        parsedJson['longitude_two'],
        parsedJson['platform_name_two'],
        parsedJson['direction_name_two']);
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "id_one": this.stop1.id,
        "name_one": this.stop1.name,
        "latitude_one": this.stop1.latitude,
        "longitude_one": this.stop1.longitude,
        "platform_name_one": this.stop1.directionDestination,
        "direction_name_one": this.stop1.directionName,
        "id_two": this.stop2.id,
        "name_two": this.stop2.name,
        "latitude_two": this.stop2.latitude,
        "longitude_two": this.stop2.longitude,
        "platform_name_two": this.stop2.directionDestination,
        "direction_name_two": this.stop2.directionName,
      };
}
