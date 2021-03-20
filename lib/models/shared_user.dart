import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pick_paper/handlers/firestore_helper.dart';

class SharedUser with ChangeNotifier {
  QueryDocumentSnapshot _user = null;

  QueryDocumentSnapshot get user => _user;

  set user(QueryDocumentSnapshot newValue) {
    _user = newValue;
    notifyListeners();
  }
}
