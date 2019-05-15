import 'dart:async';
import 'package:eventsource/eventsource.dart';
import 'package:mbta_companion/src/models/prediction.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:mbta_companion/src/utils/api_request_counter.dart';

class MBTAStreamService {
  static const baseURL = MBTAService.baseURL;
  static const apiKey = MBTAService.apiKey;

  // two element list, one datetime for each stop
  static Future<Stream<PredictionEvent>> streamPredictionsForStopId(
      String stopId) async {
    final stream = await EventSource.connect(
        "$baseURL/predictions?api_key=$apiKey&filter[stop]=$stopId&page[limit]=2");

    if (APIRequestCounter.debug) {
      APIRequestCounter.incrementCalls('prediction stream');
    }

    return stream.transform(StreamTransformer.fromHandlers(
        handleData: (Event event, EventSink sink) {
      // print("event type: ${event.event}");
      // print("event data: ${event.data}");
      if (event.event != "remove") {
        sink.add(_formulatePredictionEvent(event));
      }
    }));
  }

  // two element list, one timeofday for each stop
  static PredictionEvent _formulatePredictionEvent(Event eventObj) {
    final event = eventObj.event;
    final jsonData = json.decode(eventObj.data);

    switch (event) {
      case "reset":
        return _getResetPredictionEvent(jsonData);
      case "update":
        return _getUpdatePredictionEvent(jsonData);
      case "add":
        return _getAddPredictionEvent(jsonData);
      default:
        throw "Event type not recognized";
    }
  }

  static PredictionEvent _getResetPredictionEvent(jsonData) {
    Prediction pred1, pred2;
    try {
      pred1 = Prediction(jsonData[0]['id'],
          DateTime.parse(jsonData[0]['attributes']['arrival_time']));
    } on Exception catch (e) {
      pred1 = null;
      print("Exception: " + e.toString());
    }
    try {
      pred2 = Prediction(jsonData[1]['id'],
          DateTime.parse(jsonData[1]['attributes']['arrival_time']));
    } on Exception catch (e) {
      pred2 = null;
      print("Exception: " + e.toString());
    }
    return PredictionEvent("reset", [pred1, pred2]);
  }

  static PredictionEvent _getAddPredictionEvent(jsonData) {
    return PredictionEvent("add", [_getSinglePrediction(jsonData)]);
  }

  static PredictionEvent _getUpdatePredictionEvent(jsonData) {
    return PredictionEvent("update", [_getSinglePrediction(jsonData)]);
  }

  static Prediction _getSinglePrediction(jsonData) {
    Prediction pred;
    try {
      pred = Prediction(jsonData['id'],
          DateTime.parse(jsonData['attributes']['arrival_time']));
    } on Exception catch (e) {
      pred = null;
      print("Exception: " + e.toString());
    }
    return pred;
  }

  static Future<PredictionEvent> getSinglePrediction(String stopId) async {
    final response = await http.get(
        "$baseURL/predictions?api_key=$apiKey&filter[stop]=$stopId&page[limit]=2");

    if (APIRequestCounter.debug) {
      APIRequestCounter.incrementCalls('single prediction');
    }

    final jsonData = json.decode(response.body)['data'];

    Prediction pred1, pred2;
    if (jsonData.length > 0) {
      try {
        pred1 = Prediction(jsonData[0]['id'],
            DateTime.parse(jsonData[0]['attributes']['arrival_time']));
      } on Exception catch (e) {
        pred1 = null;
        print("Exception: " + e.toString());
      }
    }
    if (jsonData.length > 1) {
      try {
        pred2 = Prediction(jsonData[1]['id'],
            DateTime.parse(jsonData[1]['attributes']['arrival_time']));
      } on Exception catch (e) {
        pred2 = null;
        print("Exception: " + e.toString());
      }
    }

    return PredictionEvent("single", [pred1, pred2]);
  }
}
