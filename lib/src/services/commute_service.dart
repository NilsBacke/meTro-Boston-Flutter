import 'dart:async';
import 'dart:io' show Platform;
import 'package:mbta_companion/src/models/commute.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommuteService {
  static Future<Commute> getCommute() async {
    try {
      String udid = await FlutterUdid.udid;

      final stage = Platform.environment["FIREBASE_STAGE"];

      var docRef = Firestore.instance
          .collection(stage)
          .document(stage)
          .collection("users")
          .document(udid);
      // TODO: change staging

      var doc = await docRef.get();
      if (!doc.exists) {
        throw new Exception("Doc does not exist"); // TODO: revisit approach
      }
      return Commute.fromJson(Map<String, dynamic>.from(doc.data));
    } catch (e) {
      if (e.message == "Doc does not exist") {
        throw new Exception(e.message);
      } else {
        print('$e');
        throw new Exception("Could not load commute");
      }
    }
  }

  static Future<void> saveCommute(Commute commute) async {
    try {
      String udid = await FlutterUdid.udid;

      final stage = Platform.environment["FIREBASE_STAGE"];

      var docRef = Firestore.instance
          .collection(stage)
          .document(stage)
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

      final stage = Platform.environment["FIREBASE_STAGE"];

      var docRef = Firestore.instance
          .collection(stage)
          .document(stage)
          .collection("users")
          .document(udid);
      await docRef.delete();
    } catch (e) {
      throw new Exception("Could not delete commute");
    }
  }
}
