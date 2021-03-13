import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pick_paper/handlers/firestore_helper.dart';
import 'package:pick_paper/models/shared_location.dart';
import 'package:pick_paper/models/shared_user.dart';
import 'package:provider/provider.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController _mapController;
  Location _location = new Location();
  List<Marker> _markers = [Marker()];
  Marker _currentLocationMarker;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double mapHeight = (MediaQuery.of(context).size.height * 0.5);
    double mapWidth = (MediaQuery.of(context).size.width);
    double iconSize = 50;
    final _centerPosition = Provider.of<SharedLocation>(context);
    final _user = Provider.of<SharedUser>(context);
    return Container(
      child: FutureBuilder<GeoPoint>(
        future: _getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            GeoPoint currentPosition = snapshot.data;

            _centerPosition.location =
                GeoPoint(currentPosition.latitude, currentPosition.longitude);

            return Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      _mapController = controller;
                    });
                  },
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  gestureRecognizers: Set()
                    ..add(Factory<EagerGestureRecognizer>(
                        () => EagerGestureRecognizer())),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentPosition.latitude, currentPosition.longitude),
                    zoom: 17,
                  ),
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  onCameraMove: (CameraPosition position) {
                    _centerPosition.location = GeoPoint(
                        position.target.latitude, position.target.longitude);
                  },
                ),
                Positioned(
                  top: mapHeight / 2 - iconSize,
                  left: mapWidth / 2 - iconSize,
                  child: Image.asset(
                    "images/pickPaperMarker.png",
                    scale: 2,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Opacity(
                    opacity: 0.9,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(2)),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Save location"),
                              content: TextFormField(
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: "Name this location",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (controller.text != null &&
                                        controller.text != "") {
                                      FirestoreHelper.addToSavedLocation(_user,
                                          controller.text, _centerPosition);
                                      controller.text = "";
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text("Save"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.black87,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<GeoPoint> _getCurrentLocation() async {
    GeoPoint locationOfEthiopia = GeoPoint(9.1450, 40.4897);
    _currentLocationMarker = Marker(
      position:
          LatLng(locationOfEthiopia.latitude, locationOfEthiopia.longitude),
      infoWindow: InfoWindow(title: "Current location"),
    );
    _markers[0] = _currentLocationMarker;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return locationOfEthiopia;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return locationOfEthiopia;
      }
    }

    _locationData = await _location.getLocation();
    _currentLocationMarker = Marker(
      position: LatLng(_locationData.latitude, _locationData.longitude),
      infoWindow: InfoWindow(title: "Current location"),
    );
    _markers[0] = _currentLocationMarker;
    return GeoPoint(_locationData.latitude, _locationData.longitude);
  }

  _goto(GeoPoint position) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 17,
    )));
  }
}
