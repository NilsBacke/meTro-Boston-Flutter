import 'dart:async';
import 'package:mbta_companion/src/models/commute.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommuteService {
  static Future<Commute> getCommute() async {
    try {
      String udid = await FlutterUdid.udid;
      var docRef = Firestore.instance
          .collection("staging")
          .document("staging")
          .collection("users")
          .document(udid);
      // TODO: change staging
      var doc = await docRef.get();
      return Commute.fromJson(doc.data);
    } catch (e) {
      throw new Exception("Could not load commute");
    }
  }

  static Future<void> saveCommute(Commute commute) async {
    try {
      String udid = await FlutterUdid.udid;
      var docRef = Firestore.instance
          .collection("staging")
          .document("staging")
          .collection("users")
          .document(udid);
      await docRef.setData(commute.toJson());
    } catch (e) {
      throw new Exception("Could not save commute");
    }
  }

  static Future<void> deleteCommute(Commute commute) async {
    try {
      String udid = await FlutterUdid.udid;
      var docRef = Firestore.instance
          .collection("staging")
          .document("staging")
          .collection("users")
          .document(udid);
      await docRef.delete();
    } catch (e) {
      throw new Exception("Could not delete commute");
    }
  }
}
