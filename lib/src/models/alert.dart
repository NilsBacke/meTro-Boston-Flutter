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

  static const idKey = "id";
  static const startDateKey = "start";
  static const endDateKey = "end";
  static const activePeriodKey = "active_period";
  static const attributesKey = "attributes";
  static const timeframeKey = "timeframe";
  static const titleKey = "service_effect";
  static const subtitleKey = "short_header";
  static const descriptionKey = "description";
  static const updatedAtKey = "updated_at";

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
    this.id = parsedJson[idKey];
    final attr = parsedJson[attributesKey];
    this.startDate = DateTime.parse(attr[activePeriodKey][0][startDateKey]);
    this.endDate = DateTime.parse(attr[activePeriodKey][0][endDateKey]);
    this.timeframe = attr[timeframeKey];
    this.title = attr[titleKey];
    this.subtitle = attr[subtitleKey];
    this.description = attr[descriptionKey];
    this.updatedAt = DateTime.parse(attr[updatedAtKey]);
  }
}
