import 'dart:async';
import 'package:eventsource/eventsource.dart';
import 'package:mbta_companion/src/models/prediction.dart';
import 'package:mbta_companion/src/services/mbta_service.dart';
import 'dart:convert';

import 'package:mbta_companion/src/utils/api_request_counter.dart';

class MBTAStreamService {
  static const baseURL = MBTAService.baseURL;
  static const apiKey = MBTAService.apiKey;

  // two element list, one datetime for each stop
  static Future<Stream<List<Prediction>>> streamPredictionsForStopId(
      String stopId) async {
    final stream = await EventSource.connect(
        "$baseURL/predictions?api_key=$apiKey&filter[stop]=$stopId&page[limit]=2");

    if (APIRequestCounter.debug) {
      APIRequestCounter.incrementCalls('prediction stream');
    }

    return stream.transform(StreamTransformer.fromHandlers(
        handleData: (Event event, EventSink sink) {
      print("event type: ${event.event}");
      print("event data: ${event.data}");
      if (event.event == "reset" || event.event == "update") {
        sink.add(_getTimeFromStreamResponse(event.data));
      }
    }));
  }

  // two element list, one timeofday for each stop
  static List<Prediction> _getTimeFromStreamResponse(String jsonStr) {
    final jsonData = json.decode(jsonStr);

    if (jsonData.length == 0 || jsonData is Map) {
      Prediction pred;
      try {
        pred = Prediction(jsonData['id'],
            DateTime.parse(jsonData['attributes']['arrival_time']));
      } on Exception catch (e) {
        pred = null;
        print("Exception: " + e.toString());
      }
      return [pred, null];
    } else if (jsonData.length == 1) {
      Prediction pred;
      try {
        pred = Prediction(jsonData[0]['id'],
            DateTime.parse(jsonData[0]['attributes']['arrival_time']));
      } on Exception catch (e) {
        pred = null;
        print("Exception: " + e.toString());
      }
      return [pred, null];
    } else {
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
      return [pred1, pred2];
    }
  }
}
