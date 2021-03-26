import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class RequestEvent {}

class LoadRequests extends RequestEvent {
  final String userDocId;

  LoadRequests(this.userDocId);
}

class CreateRequest extends RequestEvent {
  final String userDocId, photoURL;
  final int mass;
  final GeoPoint pickUpSpot;

  CreateRequest(
      {@required this.userDocId,
      @required this.photoURL,
      @required this.mass,
      @required this.pickUpSpot});
}

class CancelRequest extends RequestEvent {
  final String requestId;

  CancelRequest(this.requestId);
}
