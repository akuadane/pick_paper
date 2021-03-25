import 'package:cloud_firestore/cloud_firestore.dart';

class UserState {}

class SignedIn extends UserState {
  final QueryDocumentSnapshot user;

  SignedIn(this.user);
}

class SignOut extends UserState {}

class SignInError extends UserState {}
