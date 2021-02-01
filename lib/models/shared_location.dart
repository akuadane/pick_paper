import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SharedLocation with ChangeNotifier {
  GeoPoint _location;

  GeoPoint get location => _location;

  set location(GeoPoint newValue) {
    _location = newValue;
    notifyListeners();
  }
}
