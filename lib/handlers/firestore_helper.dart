import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pick_paper/models/shared_location.dart';
import 'package:provider/provider.dart';
import 'package:pick_paper/models/shared_user.dart';

class FirestoreHelper {
  static final _firestoreInstance = FirebaseFirestore.instance;

  static Future<void> createUser(String phoneNumber, String uid) {
    _firestoreInstance.collection("users").add({
      "phone": phoneNumber,
      "name": "An environment savvy",
      "dateOfSignUp": Timestamp.now(),
      "uid": uid,
      "badge": "Beginner",
      "paperRecycled": 0,
      "profilePictureURL": "",
      "savedAddresses": {},
      "totalRequestsMade": 0,
    });
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

  static Stream<DocumentSnapshot> getCollectorStream(String docId) {
    return _firestoreInstance.collection("collectors").doc(docId).snapshots();
  }

  static Future<void> updateProfilePicture(
      String userDocId, String photoURL, SharedUser sharedUser) {
    _firestoreInstance
        .collection("users")
        .doc(userDocId)
        .update({"profilePictureURL": photoURL});

    getUser(userDocId).then((value) {
      sharedUser.user = value.docs[0];
    });
  }

  static Future<void> updateUserName(String userDocId, String newName) {
    _firestoreInstance
        .collection("users")
        .doc(userDocId)
        .update({"name": newName});
  }

  static Future<DocumentReference> createRequest(QueryDocumentSnapshot user,
      int mass, String photoURL, GeoPoint pickUpSpot) {
    String userDocId = user.id;

    _firestoreInstance.collection("users").doc(userDocId).update(
      {"totalRequestsMade": user["totalRequestsMade"] + 1},
    );

    return _firestoreInstance.collection("recyclingRequests").add({
      "dateOfRequest": Timestamp.now(),
      "dateOfAcceptance": null,
      "mass": mass,
      "placeOfPickup": pickUpSpot,
      "status": 0,
      "photoURL": photoURL,
      "fromUser": _firestoreInstance.collection("users").doc(userDocId),
      "acceptedByCollector": null,
      "rating": {
        "rated": false,
        "rating": 0,
      },
    });
  }

  static Stream<QuerySnapshot> getUserRequests(String userDocId) {
    return _firestoreInstance
        .collection("recyclingRequests")
        .where("fromUser",
            isEqualTo: _firestoreInstance.collection("users").doc(userDocId))
        .where("status", isNotEqualTo: 4)
        .snapshots();
  }

  static Future<void> cancleRequest(String requestId) {
    _firestoreInstance.collection("recyclingRequests").doc(requestId).update({
      "status": 4,
    });
  }

  static Future<void> addToSavedLocation(
      SharedUser sharedUser, String name, GeoPoint location) async {
    final user = sharedUser.user;
    print(location.longitude);
    Map<String, dynamic> locationMap = user["savedAddresses"];
    locationMap[name] = location;

    _firestoreInstance
        .collection("users")
        .doc(user.id)
        .update({"savedAddresses": locationMap});

    getUser(user.id).then((value) {
      sharedUser.user = value.docs[0];
    });
  }

  static Future<void> rateCollectorForTheFirstTime(
      DocumentSnapshot collector, double rating, String requestDocId) async {
    var oldRating = collector["rating"];

    double averageRating =
        (oldRating["rating"] * oldRating['ratedTimes'] + rating) /
            (oldRating["ratedTimes"] + 1);

    averageRating = double.parse(averageRating.toStringAsFixed(1));

    var newRating = oldRating;
    newRating["${rating.round()}"]++;
    newRating["ratedTimes"]++;
    newRating["rating"] = averageRating;

    await _firestoreInstance
        .collection("recyclingRequests")
        .doc(requestDocId)
        .update({
      "rating": {
        "rated": true,
        "rating": rating,
      }
    }); // Changes the rating map on the request document

    await _firestoreInstance
        .collection("collectors")
        .doc(collector.id)
        .update({"rating": newRating});
  }

  static Future<void> changeRatingForCollector(DocumentSnapshot collector,
      double rating, String requestDocId, double prevRating) async {
    var oldRating = collector["rating"];

    double ratingWithOutPrevRating = (oldRating["rating"] *
                oldRating['ratedTimes'] -
            prevRating) /
        (oldRating["ratedTimes"] -
            1); // rating without the previous rating that is going to be changed
    oldRating["${prevRating.round()}"]--; // substracting the previous rating
    oldRating["rating"] = ratingWithOutPrevRating;
    oldRating["ratedTimes"]--;

    double averageRating =
        (oldRating["rating"] * oldRating['ratedTimes'] + rating) /
            (oldRating["ratedTimes"] + 1);

    var newRating = oldRating;
    averageRating = double.parse(averageRating.toStringAsFixed(1));

    newRating["${rating.round()}"]++;
    newRating["ratedTimes"]++;
    newRating["rating"] = averageRating;

    await _firestoreInstance
        .collection("recyclingRequests")
        .doc(requestDocId)
        .update({
      "rating": {
        "rated": true,
        "rating": rating,
      }
    }); // Changes the rating map on the request document

    await _firestoreInstance
        .collection("collectors")
        .doc(collector.id)
        .update({"rating": newRating});
  }
}
