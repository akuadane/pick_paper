import 'package:cloud_firestore/cloud_firestore.dart';

class SavedLocation {
  final String name;
  final GeoPoint location;

  SavedLocation(this.name, this.location);

  @override
  String toString() {
    return "$name";
  }

  bool operator ==(dynamic other) =>
      other != null && other is SavedLocation && this.name == other.name;

  @override
  int get hashCode => super.hashCode;
}
