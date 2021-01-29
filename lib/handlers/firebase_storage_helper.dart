import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageHelper {
  static final _firebaseStorageInstance = FirebaseStorage.instance;

  static Future<String> uploadProfilePicture(
      File image, String userDocId) async {
    UploadTask task = _firebaseStorageInstance
        .ref("profilePictures/$userDocId/profilePicture")
        .putFile(image);

    try {
      TaskSnapshot snapshot = await task;
      return snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      return "";
    }
  }

  static Future<String> uploadPaperPhoto(File image, String userDocId) async {
    // String uuid = Uuid().v1; // gives a unique name for every photo
    String uuid = "";
    UploadTask task =
        _firebaseStorageInstance.ref("papers/$userDocId/$uuid").putFile(image);

    try {
      TaskSnapshot snapshot = await task;
      return snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      return "";
    }
  }
}
