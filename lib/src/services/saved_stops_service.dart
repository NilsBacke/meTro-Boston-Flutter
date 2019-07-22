import 'dart:async';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mbta_companion/src/models/stop.dart';

class SavedStopsService {
  static Future<List<Stop>> getSavedStops() async {
    try {
      String udid = await FlutterUdid.udid;
      var docRef = Firestore.instance
          .collection("staging")
          .document("staging")
          .collection("users")
          .document(udid)
          .collection("saved_stops");
      // TODO: change staging
      var docs = await docRef.getDocuments();
      List<Stop> stops = [];
      for (int i = 0; i < docs.documents.length; i++) {
        stops.add(Stop.from(docs.documents[i].data));
      }
      return stops;
    } catch (e) {
      throw new Exception("Could not load saved stops");
    }
  }

  static Future<void> saveStop(Stop stop) async {
    try {
      String udid = await FlutterUdid.udid;
      var docRef = Firestore.instance
          .collection("staging")
          .document("staging")
          .collection("users")
          .document(udid)
          .collection("saved_stops")
          .document(stop.id);
      await docRef.setData(stop.toJson());
    } catch (e) {
      throw new Exception("Could not add stop");
    }
  }

  static Future<void> removeStop(Stop stop) async {
    try {
      String udid = await FlutterUdid.udid;
      var docRef = Firestore.instance
          .collection("staging")
          .document("staging")
          .collection("users")
          .document(udid)
          .collection("saved_stops")
          .document(stop.id);
      await docRef.delete();
    } catch (e) {
      throw new Exception("Could not remove stop");
    }
  }
}
