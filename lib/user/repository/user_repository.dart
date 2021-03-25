import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pick_paper/user/data_provider/user_provider.dart';

class UserRepository {
  final UserProvider userProvider;

  UserRepository(this.userProvider);

  Future<void> createUser(String phoneNumber, String uid) {
    return this.userProvider.createUser(phoneNumber, uid);
  }

  Future<QueryDocumentSnapshot> getUser(String uid) {
    return this.userProvider.getUser(uid);
  }

  Future<void> updateUser(Map<String, dynamic> tobeUpdated, String userDocId) {
    return this.userProvider.updateUser(tobeUpdated, userDocId);
  }

  Future<String> uploadProfilePicture(File image, String userDocId) {
    this.userProvider.uploadProfilePicture(image, userDocId);
  }

  void signOut() {
    this.userProvider.signOut();
  }
}
