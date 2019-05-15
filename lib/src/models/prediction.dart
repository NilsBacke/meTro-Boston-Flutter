class Prediction {
  final String id;
  final DateTime time;

  Prediction(this.id, this.time);
}

class PredictionEvent {
  final String event;
  final List<Prediction> predictions; // length 2 for reset, 1 for update/add

  PredictionEvent(this.event, this.predictions) {
    if (this.event == "reset") {
      assert(this.predictions.length == 2);
    }
    if (this.event == "update" || this.event == "add") {
      assert(this.predictions.length == 1);
    }
  }
}
