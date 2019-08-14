class Alert {
  String stopId;
  String id;
  DateTime startDate;
  DateTime endDate;
  String timeframe;
  String title; // service effect
  String subtitle; // header
  String description;
  DateTime updatedAt;

  static const stopIdKey = "stopId";
  static const idKey = "id";
  static const startDateKey = "startDate";
  static const endDateKey = "endDate";
  static const timeframeKey = "timeframe";
  static const titleKey = "title";
  static const subtitleKey = "subtitle";
  static const descriptionKey = "description";
  static const updatedAtKey = "updatedAt";

  Alert(
      {this.id,
      this.stopId,
      this.startDate,
      this.endDate,
      this.timeframe,
      this.title,
      this.subtitle,
      this.description,
      this.updatedAt});

  Alert.fromJson(parsedJson) {
    this.stopId = parsedJson[stopIdKey].toString();
    this.id = parsedJson[idKey];
    this.startDate = DateTime.parse(parsedJson[startDateKey]);
    if (parsedJson[endDateKey] != null) {
      this.endDate = DateTime.parse(parsedJson[endDateKey]);
    } else {
      this.endDate = null;
    }
    this.timeframe = parsedJson[timeframeKey];
    this.title = parsedJson[titleKey];
    this.subtitle = parsedJson[subtitleKey];
    this.description = parsedJson[descriptionKey];
    this.updatedAt = DateTime.parse(parsedJson[updatedAtKey]);
  }
}
