import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  static final _firebaseStorageInstance = FirebaseStorage.instance;

  static Future<void> uploadProfilePicture(File image, String userDocId) {
    _firebaseStorageInstance
        .ref()
        .child("profilePictures")
        .child(userDocId)
        .child("profilePicture")
        .putFile(image)
        .whenComplete(() => null);
  }
}
