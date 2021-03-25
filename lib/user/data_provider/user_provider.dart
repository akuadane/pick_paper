import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserProvider {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final _firebaseStorageInstance = FirebaseStorage.instance;
  static final _authInstance = FirebaseAuth.instance;

  Future<void> createUser(String phoneNumber, String uid) {
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

  Future<QueryDocumentSnapshot> getUser(String uid) async {
    QuerySnapshot userSnapshot = await _firestoreInstance
        .collection("users")
        .where("uid", isEqualTo: uid)
        .get();

    if (userSnapshot.docs.length == 0)
      throw Exception("User is not found");
    else
      return userSnapshot.docs[0];
  }

  Future<void> updateUser(Map<String, dynamic> tobeUpdated, String userDocId) {
    _firestoreInstance.collection("users").doc(userDocId).update(tobeUpdated);
  }

  Future<String> uploadProfilePicture(File image, String userDocId) async {
    UploadTask task = _firebaseStorageInstance
        .ref("profilePictures/$userDocId/profilePicture")
        .putFile(image);

    try {
      TaskSnapshot snapshot = await task;
      return snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception("Unable to upload photo");
    }
  }

  signOut() {
    _authInstance.signOut();
  }
}
