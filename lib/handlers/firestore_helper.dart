import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreHelper {
  static final _firestoreInstance = FirebaseFirestore.instance;

  static Future<void> createUser(String phoneNumber, String uid) {
    _firestoreInstance.collection("users").add({
      "phone": phoneNumber,
      "name": "An environment savvy",
      "dateOfSignUp": Timestamp.now(),
      "uid": uid,
      "badge": "",
      "paperRecycled": 0,
      "profilePictureURL": "",
      "savedAddresses": [],
      "totalRequestsMade": 0,
    });
  }

  static Stream<QuerySnapshot> getUsers() {
    return _firestoreInstance.collection("users").snapshots();
  }

  static Future<QuerySnapshot> getUser(String uid) {
    return _firestoreInstance
        .collection("users")
        .where("uid", isEqualTo: uid)
        .get();
  }

  static Stream<QuerySnapshot> getUserStream(String uid) {
    return _firestoreInstance
        .collection("users")
        .where("uid", isEqualTo: uid)
        .snapshots();
  }

  static Future<void> updateProfilePicture(String userDocId, String photoURL) {
    _firestoreInstance
        .collection("users")
        .doc(userDocId)
        .update({"profilePictureURL": photoURL});
  }

  static Future<void> updateUserName(String userDocId, String newName) {
    _firestoreInstance
        .collection("users")
        .doc(userDocId)
        .update({"name": newName});
  }

  static Future<void> createRequest(
      String userDocId, int mass, String photoUR, GeoPoint pickUpSpot) {
    _firestoreInstance.collection("recyclingRequests").add({
      "dateOfRequest": Timestamp.now(),
      "mass": mass,
      "placeOfPickup": pickUpSpot,
      "live": 0,
      "fromUser": _firestoreInstance.collection("users").doc(userDocId),
    });
  }

  static Future<void> cancleRequest(String requestId) {
    _firestoreInstance.collection("recyclingRequests").doc(requestId).update({
      "live": 4,
    });
  }
}
