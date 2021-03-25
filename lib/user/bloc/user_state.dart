import 'package:cloud_firestore/cloud_firestore.dart';

class UserState {}

class SignedIn extends UserState {
  final QueryDocumentSnapshot user;

  SignedIn(this.user);
}

class SigningIn extends UserState {}

class SignedOut extends UserState {}

class SignInError extends UserState {}

class UploadingPhotoError extends UserState {}
