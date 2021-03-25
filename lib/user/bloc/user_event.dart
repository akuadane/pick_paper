import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserEvent {}

class SignIn extends UserEvent {
  final QueryDocumentSnapshot user;

  SignIn(this.user);
}

class CreateUser extends UserEvent {
  final String phoneNumber, uid;

  CreateUser({@required this.phoneNumber, @required this.uid});
}

class GetUser extends UserEvent {
  final String userDocId;

  GetUser(this.userDocId);
}

class UpdateUser extends UserEvent {
  final Map<String, dynamic> tobeUpdated;
  final String userDocId;

  UpdateUser({@required this.tobeUpdated, @required this.userDocId});
}

class UploadProfilePicture extends UserEvent {
  final File image;
  final String userDocId;

  UploadProfilePicture({@required this.image, @required this.userDocId});
}

class SignOut extends UserEvent {}

class FireSignInError extends UserEvent {}
